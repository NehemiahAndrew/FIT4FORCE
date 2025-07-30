-- Fit4Force Device Management System Setup
-- Run this in Supabase Dashboard → SQL Editor

-- Create user_devices table
CREATE TABLE public.user_devices (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    device_id TEXT NOT NULL,
    device_name TEXT NOT NULL,
    device_type TEXT NOT NULL CHECK (device_type IN ('mobile', 'tablet', 'desktop')),
    platform TEXT NOT NULL CHECK (platform IN ('iOS', 'Android', 'Web', 'Windows', 'macOS', 'Linux')),
    is_active BOOLEAN DEFAULT TRUE,
    last_login TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Additional device info for better identification
    device_model TEXT,
    os_version TEXT,
    app_version TEXT,
    
    -- Unique constraint to prevent duplicate device registrations
    UNIQUE(user_id, device_id)
);

-- Create indexes for better performance
CREATE INDEX idx_user_devices_user_id ON public.user_devices(user_id);
CREATE INDEX idx_user_devices_active ON public.user_devices(user_id, is_active);
CREATE INDEX idx_user_devices_last_login ON public.user_devices(last_login);

-- Enable Row Level Security
ALTER TABLE public.user_devices ENABLE ROW LEVEL SECURITY;

-- RLS Policies for user_devices table
-- Users can only access their own device records
CREATE POLICY "Users can view their own devices" ON public.user_devices
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own devices" ON public.user_devices
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own devices" ON public.user_devices
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own devices" ON public.user_devices
    FOR DELETE USING (auth.uid() = user_id);

-- Function to automatically update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger to automatically update updated_at
CREATE TRIGGER update_user_devices_updated_at
    BEFORE UPDATE ON public.user_devices
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Function to check device limit before allowing new device registration
CREATE OR REPLACE FUNCTION check_device_limit()
RETURNS TRIGGER AS $$
DECLARE
    active_device_count INTEGER;
    max_devices INTEGER := 2; -- Maximum allowed devices per user
BEGIN
    -- Count active devices for this user (excluding the current device if updating)
    SELECT COUNT(*) INTO active_device_count
    FROM public.user_devices
    WHERE user_id = NEW.user_id 
    AND is_active = TRUE
    AND (TG_OP = 'INSERT' OR id != NEW.id);
    
    -- If inserting a new active device and limit would be exceeded
    IF TG_OP = 'INSERT' AND NEW.is_active = TRUE AND active_device_count >= max_devices THEN
        RAISE EXCEPTION 'Device limit exceeded. Maximum % active devices allowed per user.', max_devices;
    END IF;
    
    -- If updating to active and limit would be exceeded
    IF TG_OP = 'UPDATE' AND NEW.is_active = TRUE AND OLD.is_active = FALSE AND active_device_count >= max_devices THEN
        RAISE EXCEPTION 'Device limit exceeded. Maximum % active devices allowed per user.', max_devices;
    END IF;
    
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger to enforce device limit
CREATE TRIGGER enforce_device_limit
    BEFORE INSERT OR UPDATE ON public.user_devices
    FOR EACH ROW
    EXECUTE FUNCTION check_device_limit();

-- Function to automatically deactivate old devices (run daily)
CREATE OR REPLACE FUNCTION cleanup_inactive_devices()
RETURNS INTEGER AS $$
DECLARE
    affected_rows INTEGER;
BEGIN
    -- Deactivate devices that haven't been used in 7 days
    UPDATE public.user_devices
    SET is_active = FALSE,
        updated_at = NOW()
    WHERE is_active = TRUE
    AND last_login < NOW() - INTERVAL '7 days';
    
    GET DIAGNOSTICS affected_rows = ROW_COUNT;
    
    -- Optionally delete very old device records (older than 30 days)
    DELETE FROM public.user_devices
    WHERE is_active = FALSE
    AND updated_at < NOW() - INTERVAL '30 days';
    
    RETURN affected_rows;
END;
$$ language 'plpgsql';

-- Function to get active device count for a user
CREATE OR REPLACE FUNCTION get_active_device_count(user_uuid UUID)
RETURNS INTEGER AS $$
DECLARE
    device_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO device_count
    FROM public.user_devices
    WHERE user_id = user_uuid AND is_active = TRUE;
    
    RETURN device_count;
END;
$$ language 'plpgsql';

-- Function to register or update a device
CREATE OR REPLACE FUNCTION register_device(
    p_user_id UUID,
    p_device_id TEXT,
    p_device_name TEXT,
    p_device_type TEXT,
    p_platform TEXT,
    p_device_model TEXT DEFAULT NULL,
    p_os_version TEXT DEFAULT NULL,
    p_app_version TEXT DEFAULT NULL
)
RETURNS JSON AS $$
DECLARE
    device_record RECORD;
    active_count INTEGER;
    result JSON;
BEGIN
    -- Check if device already exists
    SELECT * INTO device_record
    FROM public.user_devices
    WHERE user_id = p_user_id AND device_id = p_device_id;
    
    IF FOUND THEN
        -- Update existing device
        UPDATE public.user_devices
        SET device_name = p_device_name,
            device_type = p_device_type,
            platform = p_platform,
            device_model = p_device_model,
            os_version = p_os_version,
            app_version = p_app_version,
            last_login = NOW(),
            is_active = TRUE,
            updated_at = NOW()
        WHERE user_id = p_user_id AND device_id = p_device_id
        RETURNING * INTO device_record;
        
        result := json_build_object(
            'success', true,
            'action', 'updated',
            'device', row_to_json(device_record)
        );
    ELSE
        -- Check active device count before inserting
        SELECT get_active_device_count(p_user_id) INTO active_count;
        
        IF active_count >= 2 THEN
            result := json_build_object(
                'success', false,
                'error', 'device_limit_exceeded',
                'message', 'Maximum 2 active devices allowed per user',
                'active_devices', (
                    SELECT json_agg(row_to_json(d))
                    FROM (
                        SELECT id, device_name, device_type, platform, last_login
                        FROM public.user_devices
                        WHERE user_id = p_user_id AND is_active = TRUE
                        ORDER BY last_login DESC
                    ) d
                )
            );
        ELSE
            -- Insert new device
            INSERT INTO public.user_devices (
                user_id, device_id, device_name, device_type, platform,
                device_model, os_version, app_version, is_active, last_login
            ) VALUES (
                p_user_id, p_device_id, p_device_name, p_device_type, p_platform,
                p_device_model, p_os_version, p_app_version, TRUE, NOW()
            ) RETURNING * INTO device_record;
            
            result := json_build_object(
                'success', true,
                'action', 'created',
                'device', row_to_json(device_record)
            );
        END IF;
    END IF;
    
    RETURN result;
END;
$$ language 'plpgsql' SECURITY DEFINER;

-- Grant necessary permissions
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT ALL ON public.user_devices TO authenticated;
GRANT EXECUTE ON FUNCTION register_device TO authenticated;
GRANT EXECUTE ON FUNCTION get_active_device_count TO authenticated;

-- Add device management table to Supabase config constants
-- (This will be added to the Dart configuration file)

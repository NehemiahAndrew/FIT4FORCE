# Live News Sources Implementation Guide

## Overview

The Fit4Force app now supports fetching real-time news from official agency sources, RSS feeds, and news APIs. This ensures users get the latest recruitment updates, training announcements, and important information directly from their selected agency.

## Features Implemented

### 1. **News Sources Configuration**
- **File**: `lib/features/news/services/news_sources_config.dart`
- Official website URLs for all major agencies
- RSS feed endpoints for automated news fetching
- Social media handles for additional coverage
- Agency-specific keyword filters for relevance

### 2. **Live News Fetching Service**
- **File**: `lib/features/news/services/live_news_service.dart`
- Multi-strategy news fetching (RSS, Web Scraping, APIs)
- Automatic duplicate removal and content filtering
- Caching system for improved performance
- Error handling with fallback to mock data

### 3. **Updated Agency News Service**
- **File**: `lib/features/news/services/agency_news_service.dart`
- Integration with live news fetching
- Configurable live/mock data combination
- Agency-specific news filtering maintained
- Cache management and refresh capabilities

### 4. **News Sources Settings Screen**
- **File**: `lib/features/news/screens/news_sources_settings_screen.dart`
- View and manage news source configurations
- Manual refresh controls for each agency
- Cache status monitoring
- Configuration guide for setup

## Supported Agencies and Sources

| Agency | Official Website | RSS Feeds | Social Media |
|--------|------------------|-----------|--------------|
| Nigerian Army | https://www.army.mil.ng | ✅ | Twitter, Facebook, Instagram |
| Nigerian Navy | https://www.navy.mil.ng | ✅ | Twitter, Facebook, Instagram |
| Nigerian Air Force | https://www.airforce.mil.ng | ✅ | Twitter, Facebook, Instagram |
| NDA | https://www.nda.edu.ng | ✅ | Twitter, Facebook, Instagram |
| DSSC | https://www.dssc.mil.ng | ✅ | Twitter, Facebook |
| NSCDC | https://www.nscdc.gov.ng | ✅ | Twitter, Facebook, Instagram |
| Fire Service | https://www.federalfireservice.gov.ng | ✅ | Twitter, Facebook |

## News Fetching Strategies

### 1. **RSS Feed Parsing** (Primary)
- Most reliable source for structured news data
- Automatic parsing of XML feeds
- Real-time updates when agencies publish new content
- Metadata extraction (dates, categories, links)

### 2. **Web Scraping** (Fallback)
- Direct scraping of official news sections
- Used when RSS feeds are unavailable
- Intelligent content extraction using common selectors
- Respects robots.txt and rate limiting

### 3. **News APIs** (Supplementary)
- Integration with NewsAPI.org for broader coverage
- Keyword-based filtering for agency relevance
- Multiple language support
- Commercial news sources coverage

### 4. **Hybrid Approach** (Default)
- Combines all strategies for maximum coverage
- Prioritizes official sources over third-party
- Automatic deduplication across sources
- Reliability scoring for content ranking

## Configuration Setup

### 1. **API Keys (Optional but Recommended)**

Add your API keys to `news_sources_config.dart`:

```dart
static const Map<String, String> newsApiConfig = {
  'newsapi_key': 'YOUR_NEWSAPI_ORG_KEY',
  'google_news_api_key': 'YOUR_GOOGLE_NEWS_API_KEY',
  'bing_news_api_key': 'YOUR_BING_NEWS_API_KEY',
};
```

**Getting API Keys:**
- NewsAPI.org: Register at https://newsapi.org/register
- Google News API: Enable in Google Cloud Console
- Bing News API: Get from Azure Cognitive Services

### 2. **Package Dependencies**

Required packages (already added to pubspec.yaml):
```yaml
dependencies:
  http: ^0.13.6      # HTTP requests
  html: ^0.15.4      # HTML parsing for web scraping
  xml: ^6.5.0        # XML parsing for RSS feeds
```

### 3. **News Fetching Configuration**

Adjust settings in `news_sources_config.dart`:

```dart
class NewsFetchConfig {
  static const NewsFetchStrategy defaultStrategy = NewsFetchStrategy.hybrid;
  static const Duration refreshInterval = Duration(hours: 1);
  static const Duration cacheExpiry = Duration(hours: 6);
  static const int maxNewsPerAgency = 50;
  static const int maxNewsAge = 30; // days
}
```

## How It Works

### 1. **Automatic News Updates**
```dart
// News is automatically fetched when user requests agency news
final armyNews = await newsService.getPersonalizedNews('Nigerian Army');

// Live news is fetched from:
// 1. Official RSS feeds
// 2. News APIs with agency keywords
// 3. Web scraping as fallback
// 4. Mock data for testing/fallback
```

### 2. **Content Filtering and Processing**
- **Agency Filtering**: Only news relevant to user's selected agency
- **Keyword Matching**: Agency-specific keywords ensure relevance
- **Content Categorization**: Automatic classification (Recruitment, Training, etc.)
- **Priority Assignment**: Breaking news and deadlines get high priority
- **Duplicate Removal**: Similar articles are deduplicated

### 3. **Caching System**
- **Memory Cache**: Recent news cached for 6 hours
- **Automatic Refresh**: News updated every hour
- **Manual Refresh**: Users can force refresh from settings
- **Fallback Strategy**: Cached data used if live fetch fails

## User Interface Integration

### 1. **Settings Access**
- Settings icon added to agency news screen header
- Navigate to `NewsSourcesSettingsScreen` for configuration
- View cache status and manually refresh news

### 2. **News Display**
- Live news seamlessly integrated with existing UI
- Source attribution shows where news came from
- External links to original articles when available
- Indicators for live vs. cached content

### 3. **Status Indicators**
```dart
// Visual indicators for news source status
- 🟢 Live RSS Feed Available
- 🟡 Web Scraping Used
- 🔴 Mock Data Only
- ⚡ Breaking News
- 📅 Deadline Alert
```

## Testing and Validation

### 1. **Live News Testing**
```dart
// Test live news fetching for specific agency
final liveNews = await newsService.getPersonalizedNews('Nigerian Army');
print('Fetched ${liveNews.length} live news items');

// Check news sources
final newsStatus = newsService.getNewsStatus();
print('Live news enabled: ${newsStatus['live_news_enabled']}');
```

### 2. **Cache Testing**
```dart
// Check cache status
final cacheStatus = newsService.getCacheStatus();
print('Cached agencies: ${cacheStatus['cached_agencies']}');

// Clear cache for testing
newsService.clearCache('Nigerian Army');
```

### 3. **Source Validation**
- Each news item includes source attribution
- External URLs link back to original articles
- Timestamps show when content was fetched
- Reliability scores help rank content quality

## Error Handling and Fallbacks

### 1. **Network Issues**
- Timeout handling for slow connections
- Retry logic with exponential backoff
- Graceful degradation to cached content
- User notifications for connectivity issues

### 2. **Source Failures**
```dart
// Automatic fallback chain:
1. RSS Feeds (most reliable)
2. Web Scraping (medium reliability)
3. News APIs (broad coverage)
4. Mock Data (always available)
5. Cached Content (offline support)
```

### 3. **Content Quality**
- Invalid HTML/XML handling
- Malformed URL detection
- Content length validation
- Spam/irrelevant content filtering

## Performance Optimization

### 1. **Efficient Fetching**
- Parallel fetching from multiple sources
- Request debouncing to avoid rate limits
- Selective updates based on last-modified headers
- Compression support for large feeds

### 2. **Memory Management**
- Automatic cache cleanup for old content
- Limited cache size per agency
- Background processing for news updates
- Lazy loading for large news lists

### 3. **User Experience**
- Progressive loading with cached content first
- Pull-to-refresh for manual updates
- Background sync without blocking UI
- Offline support with cached news

## Monitoring and Analytics

### 1. **News Source Health**
```dart
// Monitor source availability and performance
final sourceHealth = {
  'rss_success_rate': 0.95,
  'scraping_success_rate': 0.80,
  'api_success_rate': 0.90,
  'average_fetch_time': '2.3s',
  'cache_hit_rate': 0.75,
};
```

### 2. **Content Quality Metrics**
- News relevance scoring
- User engagement tracking
- Source reliability ratings
- Content freshness monitoring

### 3. **Performance Metrics**
- Fetch time per source
- Cache efficiency rates
- Network usage optimization
- Error rate monitoring

## Future Enhancements

### 1. **Advanced Features**
- Push notifications for breaking news
- Personalized content recommendations
- Multi-language news support
- Voice news reading

### 2. **Source Expansion**
- Additional government portals
- International military news
- Educational institution feeds
- Industry-specific sources

### 3. **AI Integration**
- Smart content summarization
- Relevance scoring improvements
- Automatic topic clustering
- Sentiment analysis

## Deployment Considerations

### 1. **Production Setup**
- Configure rate limiting for APIs
- Set up monitoring for source health
- Implement error logging and alerts
- Plan for scaling news storage

### 2. **Security**
- Validate all external content
- Sanitize HTML/XML inputs
- Implement CORS policies
- Rate limit user requests

### 3. **Compliance**
- Respect robots.txt files
- Follow API terms of service
- Implement proper attribution
- Handle copyright considerations

## Troubleshooting

### Common Issues and Solutions

1. **No Live News Appearing**
   - Check internet connectivity
   - Verify API keys if using news APIs
   - Check if RSS feeds are accessible
   - Clear cache and retry

2. **Slow News Loading**
   - Check network speed
   - Verify server response times
   - Consider reducing fetch frequency
   - Use cached content while fetching

3. **Irrelevant News Content**
   - Review keyword filters for agency
   - Adjust relevance scoring
   - Report issues for filter improvements
   - Use manual filtering as backup

4. **High Data Usage**
   - Enable caching to reduce requests
   - Optimize image loading
   - Use compression for large feeds
   - Implement smart refresh strategies

## Support and Maintenance

For questions or issues with the live news implementation:

1. Check the Settings > News Sources screen for status
2. Use manual refresh to test connectivity
3. Review logs for error messages
4. Contact development team with specific error details

The live news system is designed to be robust and self-healing, automatically falling back to reliable sources when issues occur.

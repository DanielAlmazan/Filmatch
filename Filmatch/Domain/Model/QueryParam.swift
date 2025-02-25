//
//  QueryParam.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 24/12/24.
//

import Foundation

enum QueryParam: String {
  case apiKey = "api_key"
  
  case airDateGte = "air_date.gte"
  
  case airDateLte = "air_date.lte"
  
  case firstAirDateYear = "first_air_date_year"
  
  case firstAirDateYearGte = "first_air_date_year.gte"
  
  case firstAirDateYearLte = "first_air_date_year.lte"
  
  /// Use in conjunction with `QueryParam.region`
  case certification = "certification"
  
  /// Use in conjunction with `QueryParam.region`
  case certificationGte = "certification.gte"
  
  /// Use in conjunction with `QueryParam.region`
  case certificationLte = "certification.lte"
  
  /// Use in conjunction with the `certification`, `certification.gte` and `certification.lte` filters
  case certificationCountry = "certification_country"
  
  /// Defaults to false
  case includeAdult = "include_adult"
  
  /// Defaults to false
  case includeNullFirstAirDates = "include_null_first_air_dates"
  
  /// Defaults to false
  case includeVideo = "include_video"
  
  /// Defaults to en-US
  case language = "language"
  
  /// Defaults to 1
  case page = "page"
  
  ///
  case primaryReleaseYear = "primary_release_year"
  
  ///
  case primaryReleaseDateGte = "primary_release_date.gte"
  
  ///
  case primaryReleaseDateLte = "primary_release_date.lte"
  
  ///
  case region = "region"
  
  ///
  case releaseDateGte = "release_date.gte"
  
  ///
  case releaseDateLte = "release_date.lte"
  
  case screenedTheatrically = "screened_theatrically"
  
  /// Defaults to popularity.desc
  case sortBy = "sort_by"
  
  case timezone = "timezone"
  
  ///
  case voteAverageGte = "vote_average.gte"
  
  ///
  case voteAverageLte = "vote_average.lte"
  
  ///
  case voteCountGte = "vote_count.gte"
  
  ///
  case voteCountLte = "vote_count.lte"
  
  /// Use in conjunction with `with_watch_monetization_types` or `with_watch_providers`
  case watchRegion = "watch_region"
  
  /// Can be a comma (`AND`) or pipe (`OR`) separated query
  case withCast = "with_cast"
  
  /// Can be a comma (`AND`) or pipe (`OR`) separated query
  case withCompanies = "with_companies"
  
  /// Can be a comma (`AND`) or pipe (`OR`) separated query
  case withCrew = "with_crew"
  
  /// Can be a comma (`AND`) or pipe (`OR`) separated query
  case withGenres = "with_genres"
  
  /// Can be a comma (`AND`) or pipe (`OR`) separated query
  case withKeywords = "with_keywords"
  
  case withNetworks = "with_networks"
  
  ///
  case withOriginCountry = "with_origin_country"
  
  ///
  case withOriginalLanguage = "with_original_language"
  
  /// Can be a comma (`AND`) or pipe (`OR`) separated query
  case withPeople = "with_people"
  
  ///
  case withReleaseType = "with_release_type"
  
  ///
  case withRuntimeGte = "with_runtime.gte"
  
  ///
  case withRuntimeLte = "with_runtime.lte"
  
  /// Possible values are: [0, 1, 2, 3, 4, 5], can be a comma (`AND`) or pipe (`OR`) separated query
  case withStatus = "with_status"
  
  /// Possible values are: [flatrate, free, ads, rent, buy]. You can use `MonetizationType` enum.
  /// Use in conjunction with `watch_region`, can be a comma (`AND`) or pipe (`OR`) separated query
  case withWatchMonetizationTypes = "with_watch_monetization_types"
  
  /// Use in conjunction with watch_region, can be a comma (AND) or pipe (OR) separated query
  case withWatchProviders = "with_watch_providers"
  
  ///
  case withoutCompanies = "without_companies"
  
  ///
  case withoutGenres = "without_genres"
  
  ///
  case withoutKeywords = "without_keywords"
  
  ///
  case withoutWatchProviders = "without_watch_providers"
  
  /// Possible values are: [0, 1, 2, 3, 4, 5, 6], can be a comma (`AND`) or pipe (`OR`) separated query
  case withType = "with_type"
  
  ///
  case year = "year"
  
  /// Appends more queries to the response. Separate them with commas (eg. `https://api.themoviedb.org/3/movie/11?append_to_response=credits,videos`)
  case appendToResponse = "append_to_response"
  
  case query = "query"
}

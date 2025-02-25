//
//  TvSeriesAggregateCreditsAppendResponse.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 6/1/25.
//

import Foundation

final class TvSeriesAggregateCreditsAppendResponse: Identifiable, Sendable {
  let cast: [TvSeriesCastMember]
  let crew: [TvSeriesCrewMember]
}

extension TvSeriesAggregateCreditsAppendResponse: Codable {
}

/*
 adult
 backdrop_path
 created_by
 episode_run_time
 first_air_date
 genres
 homepage
 id
 in_production
 languages
 last_air_date
 last_episode_to_air
 name
 next_episode_to_air
 networks
 number_of_episodes
 number_of_seasons
 origin_country
 original_language
 original_name
 overview
 popularity
 poster_path
 production_companies
 production_countries
 seasons
 spoken_languages
 status
 tagline
 type
 vote_average
 vote_count
 aggregate_credits
 */

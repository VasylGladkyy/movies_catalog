class OmdbClient
  include Singleton
  def initialize
    @api_key = Rails.application.credentials[:omdb][:api_key]
    @root_url = 'http://www.omdbapi.com'
  end

  def by_id(id:)
    all(i: String(id))
  end

  def by_title_all(title:)
    all(s: String(title))
  end

  private

  def all(search_params = {})
    check_responce(responce: JSON.parse(RestClient.get(@root_url, params: search_params.merge!(base_params))))
  end

  def base_params
    { apikey: @api_key }
  end

  def check_search(responce:)
    responce.key?('Search') ? valid_movies_array(array: responce['Search']) : responce
  end

  def check_responce(responce:)
    responce.key?('Error') ? nil : check_search(responce: responce)
  end

  def valid_movies_array(array:)
    array.delete_if do |movie|
      Movie.exists?(imdb_id: movie['imdbID']) || movie['Type'] != 'movie' || movie['Poster'] == 'N/A'
    end
  end
end

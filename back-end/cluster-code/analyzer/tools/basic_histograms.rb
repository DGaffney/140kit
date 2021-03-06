#Results: Frequency Charts of basic data on Tweets and Users per data set
def basic_histograms(collection_id)
  collection = Collection.find({:id => collection_id})
  conditional = Analysis.conditional(collection)
  tweet_languages = Analysis.frequency_hash(Tweet, "language", conditional)
  tweet_created_ats = Analysis.frequency_hash(Tweet, "created_at", conditional)
  tweet_sources = Analysis.frequency_hash(Tweet, "source", conditional)
  tweet_locations = Analysis.frequency_hash(Tweet, "location", conditional)
  user_followers_counts = Analysis.frequency_hash(User, "followers_count", conditional)
  user_friends_counts = Analysis.frequency_hash(User, "friends_count", conditional)
  user_favourites_counts = Analysis.frequency_hash(User, "favourites_count", conditional)
  user_geo_enableds = Analysis.frequency_hash(User, "geo_enabled", conditional)
  user_statuses_counts = Analysis.frequency_hash(User, "statuses_count", conditional)
  user_langs = Analysis.frequency_hash(User, "lang", conditional)
  user_time_zones = Analysis.frequency_hash(User, "time_zone", conditional)
  user_created_ats = Analysis.frequency_hash(User, "created_at", conditional)
  
  graph_hashes = {"tweet_language" => tweet_languages, "tweet_created_at" => tweet_created_ats, "tweet_source" => tweet_sources, 
  "tweet_location" => tweet_locations, "user_followers_count" => user_followers_counts, "user_friends_count" => user_friends_counts,
  "user_favourites_count" => user_favourites_counts, "user_geo_enabled" => user_geo_enableds, "user_statuses_count" => user_statuses_counts,
  "user_lang" => user_langs, "user_time_zone" => user_time_zones, "user_created_at" => user_created_ats}
  graph_points = []
  finished_graphs = []
  graph_hashes.each_pair do |k, v|
    t = Time.ntp
    g = Graph.new({:title => "#{k}", :style => "histogram", :time_slice => t, :collection_id => collection.id}).save
    g = Graph.find({:title => "#{k}", :style => "histogram", :collection_id => collection.id})
    ugly_graph_points = []
    v.each_pair do |l, w|
      graph_point = {}
      if l.class == NilClass || (l.class == String && l.empty?)
        l = "Not Reported"
      else 
        l.to_s.gsub("\n", " ")
      end
      graph_point["label"] = l
      graph_point["value"] = w.to_s.gsub("\n", " ")
      graph_point["graph_id"] = g.id
      graph_point["collection_id"] = collection.id
      ugly_graph_points << graph_point
    end
    graph_points = graph_points+Pretty.pretty_up_labels(k, ugly_graph_points)
    finished_graphs << g
  end
  graph_points_groups = []
  graph_points_allocated = 0
  while graph_points_allocated < graph_points.length
    graph_points_groups << graph_points[graph_points_allocated..graph_points_allocated+MAX_ROW_COUNT_PER_BATCH]
    graph_points_allocated = graph_points_allocated+MAX_ROW_COUNT_PER_BATCH > graph_points.length ? graph_points.length : graph_points_allocated+MAX_ROW_COUNT_PER_BATCH
  end
  graph_points_groups.each do |group|
    Database.save_all({"graph_points" => group})
  end
  session_hash = Digest::SHA1.hexdigest(Time.ntp.to_s+rand(100000).to_s)
  `mkdir ../tmp_files/#{session_hash}/`
  `mkdir ../tmp_files/#{session_hash}/#{collection.folder_name}`
  graph_hashes.each_pair do |k,v|
    row_hashes = []
    v.collect{|l,w| row_hashes << {"label" => l, "value" => w}}
    Analysis.hashes_to_csv("../tmp_files/#{session_hash}/#{collection.folder_name}/#{k}.csv", row_hashes)
  end
  `zip -r -9 -j ../tmp_files/#{session_hash}/#{collection.folder_name} ../tmp_files/#{session_hash}/#{collection.folder_name}`
  `rsync -r ../tmp_files/#{session_hash}/#{collection.folder_name}.zip #{GRAPH_POINT_ADDRESS}`
  `rm -r ../tmp_files/#{session_hash}`
  if !collection.single_dataset
    recipient = collection.researcher.email
    subject = "#{collection.researcher.user_name}, the raw Graph data for the basic histograms in the \"#{collection.name}\" data set is complete."
    message_content = "Your CSV files are ready for download. You can grab them by clicking this link: <a href=\"http://140kit.com/files/raw_data/graph_points/#{collection.folder_name}.zip\">http://140kit.com/files/raw_data/graph_points/#{collection.folder_name}.zip</a>."
    email = PendingEmail.new({:recipient => recipient, :subject => subject, :message_content => message_content}).save
  end
  Database.update_attributes(:graphs, finished_graphs, {:written => true})
end
ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'application', :action => 'welcome'
  map.account '/account', :controller => 'researchers', :action => 'show'
  map.account_forgot '/forgot', :controller => 'account', :action => 'forgot'
  map.account_reset 'reset/:reset_code', :controller => 'account', :action => 'reset'
  # map.analytical_offerings_collection_paginate '/analytical_offerings/collection_paginate/:id', :controller => 'stream_metadatas', :action => 'collection_paginate'
  # map.analytical_offerings_associate '/analytical_offerings/:analytical_offering_id/associate/:collection_id', :controller => 'stream_metadatas', :action => 'associate'
  # map.analytical_offerings_dissociate '/analytical_offerings/:analytical_offering_id/dissociate/:collection_id', :controller => 'stream_metadatas', :action => 'dissociate'
  
  map.collections '/collections', :controller => 'collections', :action => 'index', :single_dataset => 'false'
  map.collections_manage '/collections/manage', :controller => 'collections', :action => 'manage'
  map.collection_add '/collections/add', :controller => 'collections', :action => 'creator'
  map.create_collection '/collections/create', :controller => 'collections', :action => 'create'
  map.analytical_setup '/collections/:id/analytical_setup', :controller => 'collections', :action => 'analytical_setup'
  map.collection_freeze '/collections/:id/freeze', :controller => 'collections', :action => 'freeze'
  map.datasets_curate '/collections/:id/datasets', :controller => 'stream_metadatas', :action => 'curate'
  map.analytical_offerings_curate '/collections/:id/analytical_offerings', :controller => 'analytical_offerings', :action => 'curate'
  map.collection_add_analytics '/collections/:collection_id/add/analytics/:analytical_offering_id', :controller => 'collections', :action => 'add_analytics'
  map.collection_remove_analytics '/collections/:collection_id/remove/analytics/:analytical_offering_id', :controller => 'collections', :action => 'remove_analytics'
  map.collection_mothball '/collections/:collection_id/mothoball', :controller => 'collections', :action => 'mothball'
  
  map.datasets '/datasets', :controller => 'collections', :action => 'index', :single_dataset => 'true'
  map.dataset '/datasets/:id', :controller => 'collections', :action => 'show'
  
  map.google_graph '/graphs/show/:title/:collection_id', :controller => 'graphs', :action => 'show'
  
  map.login '/login', :controller => 'account', :action => 'login'
  map.logout '/logout', :controller => 'account', :action => 'logout'
  
  map.rgraph '/rgraph/:collection_id/:style', :controller => 'networks', :action => 'rgraph'
  map.rgraph_with_logic '/rgraph/:collection_id/:style/:logic', :controller => 'networks', :action => 'rgraph'

  map.networks '/networks', :controller => 'networks', :action => 'index'
  map.network '/networks/:collection_id/:style', :controller => 'networks', :action => 'show'
  map.network_with_logic '/networks/:collection_id/:style/:logic', :controller => 'networks', :action => 'show'
  
  map.netwerk '/netwerks/:collection_id/:style', :controller => 'networks', :action => 'sh0w'
  map.netwerk_with_logic '/netwerks/:collection_id/:style/:logic', :controller => 'networks', :action => 'sh0w'

  map.news '/news', :controller => 'news', :action => 'create', :conditions => {:method => :post}
  map.news '/news', :controller => 'news', :action => 'index'
  map.new_news '/news/new', :controller => 'news', :action => 'new'
  map.news_manage 'news/manage', :controller => 'news', :action => 'manage'
  map.news '/news/:id', :controller => 'news', :action => 'update', :conditions => {:method => :put}
  map.news '/news/:id', :controller => 'news', :action => 'destroy', :conditions => {:method => :delete}
  map.news '/news/:id', :controller => 'news', :action => 'show'
  map.edit_news '/news/:id/edit', :controller => 'news', :action => 'edit'
  map.page_item 'pages/:slug', :controller => 'news', :action => 'show'
  map.page_item 'pages/:id/:slug', :controller => 'news', :action => 'show'
  
  map.researchers '/researchers', :controller => 'researchers', :action => 'index'

  map.new_scrape '/scrapes/new/:scrape_type', :controller => 'scrapes', :action => 'new'
  
  map.search '/search', :controller => 'application', :action => 'search'
  
  map.settings '/settings/:id', :controller => 'researchers', :action => 'edit'
  map.signup '/signup', :controller => 'account', :action => 'signup'
  
  map.analytical_offerings_manage 'analytical_offerings/manage', :controller => 'analytical_offerings', :action => 'manage'
  map.analytical_offering_enable 'analytical_offerings/enable/:id', :controller => 'analytical_offerings', :action => 'enable'
  map.researchers_manage 'researchers/manage', :controller => 'researchers', :action => 'manage'
  map.researcher_promote '/researchers/promote/:id', :controller => 'researchers', :action => 'promote'
  map.researcher_suspend '/researchers/suspend/:id', :controller => 'researchers', :action => 'suspend'
  map.manage_cluster '/cluster/manage', :controller => 'cluster', :action => 'manage'
  map.kill_instance '/instances/kill/:instance_type/:id', :controller => 'cluster', :action => 'kill_instance'
  map.metadatas_collection_paginate '/metadatas/collection_paginate/:id', :controller => 'stream_metadatas', :action => 'collection_paginate'
  map.metadata '/metadatas/:metadata_type/:metadata_id', :controller => 'stream_metadatas', :action => 'show'
  
  map.metadatas_curate '/collections/:id/metadatas', :controller => 'stream_metadatas', :action => 'curate'
  map.metadatas_associate '/metadatas/:metadata_id/:metadata_type/associate/:collection_id', :controller => 'stream_metadatas', :action => 'associate'
  map.metadatas_dissociate '/metadatas/:metadata_id/:metadata_type/dissociate/:collection_id', :controller => 'stream_metadatas', :action => 'dissociate'
  
  map.tweets_collection_paginate '/tweets/collection_paginate/:id', :controller => 'tweets', :action => 'collection_paginate'
  map.tweets_collection_paginate_dataset '/tweets/collection_paginate/dataset/:metadata_type/:id', :controller => 'tweets', :action => 'collection_paginate_dataset'
  
  map.user '/users/:screen_name', :controller => 'users', :action => 'show'
  map.users_collection_paginate '/users/collection_paginate/:id', :controller => 'users', :action => 'collection_paginate'
  map.users_collection_paginate_dataset '/users/collection_paginate/dataset/:metadata_type/:id', :controller => 'users', :action => 'collection_paginate_dataset'

  map.resources :whitelistings
  map.resources :auth_users
  map.resources :analytical_instances
  map.resources :analytical_offerings
  map.resources :stream_instances
  map.resources :rest_instances
  map.resources :analytical_instances
  map.resources :analysis_metadatas
  map.resources :analytical_offerings
  map.resources :collections
  map.resources :comments
  map.resources :edges
  map.resources :failures
  map.resources :graph_points
  map.resources :images
  map.resources :pending_emails
  map.resources :researchers
  map.resources :scrapes
  map.resources :stream_instances
  map.resources :tweets
  map.resources :users
  
  map.new_tickets '/tickets', :controller => 'comments', :action => 'new'
  map.tickets_manage '/tickets/manage', :controller => 'comments', :action => 'index'
  
  map.connect '/:controller/:action/:id'
  map.connect '/:controller/:action/:id.:format'
  map.researcher_page '/:user_name', :controller => 'researchers', :action => 'show'
  map.collection '/:user_name/collections/:id', :controller => 'collections', :action => 'show'
  
end

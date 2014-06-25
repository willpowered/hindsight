# notes explaining vocab, limitations, etc at the end!

# 'tables' are split into three groups -- summary data from reviews, individual reviews, and basic objects



window.EXAMPLE_DATA =

  # summary data, (generated by the server from individual reviews)

  common_desires:
    "facebook.com":
      "activity: mindless reading":
        going_well_percent: .1
        going_well_user_count: 1
        going_poorly_user_count: 9
        going_well_user_time_cost_avg: '30h'
        going_poorly_user_time_cost_avg: '50h'
        intended_user_count: 10
        total_user_count: 10

      "activity: flirting":
        going_well_percent: .2
        going_well_user_count: 1
        going_poorly_user_count: 4
        going_well_user_time_cost_avg: '10h'
        going_poorly_user_time_cost_avg: '50h'
        intended_user_count: 5
        total_user_count: 5

  best_options:
    'activity: mindless reading':
      'itunes.com/random_app':
        type: 'app'
        going_well_percent: .9
        going_well_user_upfront_time_cost_avg: '5m'
        going_well_user_currency_cost_avg: null
    'state: feeling relaxed':
      'yelp.com/dolores-park':
        type: 'venue'
        going_well_percent: .9
        going_well_user_upfront_time_cost_avg: '1h'
        going_well_user_currency_cost_avg: null

  related_desires:
    'activity: mindless reading':
      'state: feeling relaxed':
        forward_migrations: 6
        backward_migrations: 0



  # individual reviews

  reviews:
    'facebook:514190':
      'facebook.com':
        engagement:
          time: '50h'
          money: null
          usage_pattern: '???'
          as_of: 29820412
          starting: 120398123
          verified_by: 'firefox:TOKEN'
        outcomes:
          'activity: mindless reading':
            intended: true
            going: 'poorly'
            desire_abandoned: true
            replacement_desire: 'state: feeling relaxed'

  reviewers:
    'facebook.com':
      'facebook:514190':
        reviewed_at: 29820412


  # detail info about objects

  resources:
    'facebook.com':
      icon: 'URL HERE'
      title: 'Facebook'
      url: 'http://facebook.com'
      type: 'app'

  people:
    'facebook:514190':
      name: 'Joe Edelman'
      facebook_id: '514190'
      photo: '...'
      city: '<WOEID>'
      birthyear: 1976
      gender: 'm'
      # TODO: add psychographic and sociographic info (urbanness/walkability, local_cohostables, local_invitables)

  outcomes:
    'state: feeling relaxed':
      canonical_name: 'feeling relaxed'
      type: 'state'
      kind_of: 'state: feeling good'
    'activity: distance biking':
      canonical_name: 'distance biking'
      type: 'activity'
      kind_of: 'activity: biking'
    'activity: biking':
      kind_of: 'activity: exercise'

  outcome_aliases:
    'state: feeling relaxed': [
      'getting relaxed'
      'being relaxed'
      'being chill'
      'feeling chill'
    ]
    'activity: distance biking': [
      'touring (bicycle)',
      'bike trips',
    ]


  # for more active users, profile information
  # FIXME: some of this data is redundant with review data

  user_profile_resources:
    'facebook:514190':
      'facebook.com':
        added: 109283121
        engaged_from: 1029830321
        engaged_until: 1203980123

  user_profile_desires:
    'facebook:514190':
      'state: feeling relaxed':
        added: 109283121
        desired_from: 1029830321
        desired_until: 1203980123
        replacement_desire: 'virtue: boldness'


##### NOTES

# re the server-generated summary data:
#   these are naive aggregations!
#   to take demographics, locations, etc into
#   account, do your own analysis starting with the
#   'reviews' and 'people' tables


#### NOT DONE YET

# 'reviews' will have a way of encoding the engagement pattern (i.e., used an app for an hour a week, bought and then used a bicycle daily, etc) but we haven't designed it yet

# 'people' will have information about number of facebook friends in their current city, better info on location, and whatever raw info might help us nail their psychographic (fb likes?)

# we need some measures of variance / distributional irregularity in the 'common desires' and 'best options' tables, but I'm not sure what to use yet


##### TERMS USED

# upfront_time = time invested before you could see an outcome is 'going well'
# winner = someone for whom a (resource, outcome) pair is "going well"
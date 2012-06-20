Gem::Specification.new do |s|
  s.name = 'endless_collection_rails2'
  s.authors = ['ASEE']
  s.summary = 'Endless Collections for Rails'
  s.description = 'Back-end infrastructure for Endless Collections.  Requires front-end package as well to work correctly.'
  s.files = `git ls-files`.split("\n")
  s.version = "0.0.1"

  s.add_dependency 'rails', '>= 2.3.11'
  s.add_dependency 'json'

end
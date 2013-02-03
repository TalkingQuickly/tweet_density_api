collection @tags => :tags
attributes :term
node :density do |t|
  t.get_density
end
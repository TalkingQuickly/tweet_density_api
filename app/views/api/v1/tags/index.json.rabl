collection @tags => :tags
attributes :term
node :density do |t|
  if (a=t.get_density) == -1
    0
  else
    a
  end
end
node :difficulty do |t|
  t.get_difficulty
end
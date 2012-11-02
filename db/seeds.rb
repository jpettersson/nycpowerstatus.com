# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'coned'
c = Coned.new
c.fetch

c.data.areas.each {|b| 
	puts "Burough: #{b.area_name}:"
	area = Area.create!({:area_name => b.area_name, :latitude => b.latitude, :longitude => b.longitude})
	#AreaSample.create!({:area_id => area.id, :total_custs => b.total_custs, :custs_out => b.custs_out, :etr => b.etr, :etrmillis => b.etrmillis})
	b.areas.each {|n|
		puts "	Neighborhood: #{n.area_name}"
		sub_area = Area.create!({:parent => area, :area_name => n.area_name, :latitude => n.latitude, :longitude => n.longitude})
		#AreaSample.create!({:area_id => sub_area.id, :total_custs => n.total_custs, :custs_out => n.custs_out, :etr => n.etr, :etrmillis => n.etrmillis})
	}
} 

Area.sample! true
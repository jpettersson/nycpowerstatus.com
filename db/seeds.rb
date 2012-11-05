# Create the supported providers & sample some data.

[
  {:code => 'ConEd', :name => "Con Edison", :provider_type => 'electricity', :url => 'http://www.conedison.com/'},
  {:code => 'LIPA', :name => "Long Island Power Authority", :provider_type => 'electricity', :url => 'http://www.lipower.org/'}
].each do |p|
    unless provider = Provider.find_by_name(p[:name])
       provider = Provider.create!(p)
    end

    begin
      provider.sample! true
    rescue Exception => msg
      puts msg
    end
end
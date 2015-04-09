require 'semantics3'
require 'rubygems'
require 'spreadsheet' 
require 'json'
require 'forkmanager'
API_KEY = 'xxxx'
API_SECRET = 'xxx'
sem3 = Semantics3::Products.new(API_KEY,API_SECRET)
    max_procs = 50 # number of parallel processes to run
     pm = Parallel::ForkManager.new(max_procs) # initiate the parallel fork manager with the max number of procs specified
     
     pm.run_on_start do |pid,ident|
       puts "Starting to do something with file #{ident}, pid: #{pid}"
     end

     pm.run_on_finish do |pid,exit_code,ident|
      puts "Finished doing something with file #{ident}"
    end
    
    files = ["v1.upcs","v2.upcs","v3.upcs","v4.upcs","v5.upcs"]
    urls = Array.new
    files.each do |file|
      pid = pm.start(file) and next # start the process
      #files.each do |file|
      counter = 0
      File.open("#{file}.csv", 'a+') do |f|
        File.open("#{file}_missing.csv", 'a+') do |miss|
          File.open("#{file}_correct.csv", 'a+') do |correct|
            File.open("#{file}_sample.csv", 'w+') do |sa|
              File.foreach(file) do |l|
                counter = counter + 1
                sa.print "#{counter}\t"
                sem3.products_field( "upc", l )
                productsHash = sem3.get_products
                if productsHash.has_key?("message")
                  puts "Result Array not found"
                  f.print "\t\t\t#{l}"
                  miss.print l
                  correct.print "\n"
                  sa.print "\n"
                else
                  parray = productsHash["results"][0]
    #prod.each do |parray|

    if parray.has_key?("name")
      puts parray["name"]
      a = parray["name"]
      b = a.gsub(/([\,\"\;\']*)/,"")
      f.print "#{b}\t"
                #miss.print "\n"
                correct.print "#{b}\t"
                sa.print "#{b}\t"
              else
                puts "Name not found"
                f.print "\t"
                correct.print "\t"
                sa.print "\t"
              end
              if parray.has_key?("description")
                puts parray["description"]
                a = parray["description"]
                b = a.gsub(/([\,\"\;\']*)/,"")
                f.print "#{b}\t"
                miss.print "\n"
                correct.print "#{b}\t"
                sa.print "#{b}\t"
              else
                puts "Name not found"
                f.print "\t"
                correct.print "\t"
                sa.print "\t"
              end
              if parray.has_key?("category")
                puts parray["category"]
                c = parray["category"]
                d = c.gsub(/(\,)/,"")
                f.print "#{d}\t"
                correct.print "#{d}\t"
                sa.print "#{d}\t"
              else
                puts "category not found"
                f.print "\t"
                correct.print "\t"
                sa.print "\t"
              end
              if parray.has_key?("upc")
                puts parray["upc"]
                f.print "#{parray["upc"].gsub(/(\,)/,"")}\t"
                correct.print "#{parray["upc"].gsub(/(\,)/,"")}\t"
                sa.print "#{parray["upc"].gsub(/(\,)/,"")}\t"
              else
                puts "manufacturer not found"
                f.print "\t"
                correct.print "\t"
                sa.print "\t"
              end
              if parray.has_key?("model")
                puts parray["model"]
                f.print "#{parray["model"].gsub(/(\,)/,"\:")}\t"
                correct.print "#{parray["model"].gsub(/(\,)/,"\:")}\t"
                sa.print "#{parray["model"].gsub(/(\,)/,"\:")}\t"
              else
                puts "model not found"
                f.print "\t"
                correct.print "\t"
                sa.print "\t"
              end
              if parray.has_key?("mpn")
                puts parray["mpn"]
                f.print "#{parray["mpn"].gsub(/(\,)/,"\:")}\t"
                correct.print "#{parray["mpn"].gsub(/(\,)/,"\:")}\t"
                sa.print "#{parray["mpn"].gsub(/(\,)/,"\:")}\t"
              else
                puts "MPN not found"
                f.print "\t"
                correct.print "\t"
                sa.print "\t"
              end
              if parray.has_key?("dimension")
               puts parray["dimension"]
               f.print "#{parray["dimension"].gsub(/(\,)/,"")}\t"
               correct.print "#{parray["dimension"].gsub(/(\,)/,"")}\t"
               sa.print "#{parray["dimension"].gsub(/(\,)/,"")}\t"
             else
               puts "dimension not found"
               f.print "\t"
               correct.print "\t"
               sa.print "\t"
             end
             if parray.has_key?("weight")
              puts parray["weight"]
              f.print "#{parray["weight"].gsub(/(\,)/,"")}\t"
              correct.print "#{parray["weight"].gsub(/(\,)/,"")}\t"
              sa.print "#{parray["weight"].gsub(/(\,)/,"")}\t"
            else
              puts "weight not found"
              f.print "\t"
              correct.print "\t"
              sa.print "\t"
            end
            if parray.has_key?("brand")
             puts parray["brand"]
             f.print "#{parray["brand"].gsub(/(\,)/,"")}\t"
             correct.print "#{parray["brand"].gsub(/(\,)/,"")}\t"
             sa.print "#{parray["brand"].gsub(/(\,)/,"")}\t"
           else
             puts "upc not found"
             f.print "\t"
             correct.print "\t"
             sa.print "\t"
           end
           if parray.has_key?("price")
            puts parray["price"]
            f.print "#{parray["price"]}\t"
            correct.print "#{parray["price"]}\t"
            sa.print "#{parray["price"]}\t"
          else
            puts "price not found"
            f.print "\t"
            correct.print "\t"
            sa.print "\t"
          end
          if parray.has_key?("sitedetails")
            s = parray["sitedetails"]
            s.each do |sarry|
              if sarry.has_key?("url")
                if ( sarry["url"] =~ /(http\:\/\/www\.amazon\.com)/ )
                  puts sarry["sku"]
                  f.print "#{sarry["sku"]}\t"
                  correct.print "#{sarry["sku"]}\t"
                  sa.print "#{sarry["sku"]}\t"
                  puts sarry["url"]
                  f.print "#{sarry["url"]}\t"
                  correct.print "#{sarry["url"]}\t"
                  sa.print "#{sarry["url"]}\t"
                  sarry["latestoffers"].each do |offers|
                    if offers.has_key?("shipping")
                      puts offers["shipping"]
                      f.print "#{offers["shipping"].gsub(/(\,)/,"")}\t"
                      correct.print "#{offers["shipping"].gsub(/(\,)/,"")}\t"
                      sa.print "#{offers["shipping"].gsub(/(\,)/,"")}\t"
                    else
                      puts "Shipping price not found"
                      f.write "\t"
                      correct.print "\t"
                      sa.print "\t"
                    end
                    puts "#{sarry["name"].gsub(/(\.com)/,"")}[#{offers["seller"].gsub(/(\,)/,"")}]:$#{offers["price"]}"
                    f.print "#{sarry["name"].gsub(/(\.com)/,"")}[#{offers["seller"].gsub(/(\,)/,"")}]:$#{offers["price"]}\,"
                    correct.print "#{sarry["name"].gsub(/(\.com)/,"")}[#{offers["seller"].gsub(/(\,)/,"")}]:$#{offers["price"]}\,"
                    sa.print "#{sarry["name"].gsub(/(\.com)/,"")}[#{offers["seller"].gsub(/(\,)/,"")}]:$#{offers["price"]}\,"
                  end
                else
                  puts "Amazon url not found"
                end
                break if ( sarry["url"] =~ /(http\:\/\/www\.amazon\.com)/ )
              else
               print "no site deatils url found"
               f.print "s\t"
               correct.print "\t"
               sa.print "\t"
             end
           end
           f.print "\n"
           correct.print "\n"
           sa.print "\n"
         else
          puts "Site deatils not found"
         #f.print "\n\t"
         f.print "\n"
         correct.print "\n"
         sa.print "\n"
         #f.puts
       end

     end
   end 
 end
end
end
end
      #end
      
      # here's where you do the processing
    #{}`/usr/local/bin/super_processor #{file}`

    
     pm.finish # end process
   end

   puts "Waiting for all processes to finish..."
    pm.wait_all_children # wait for all processes to complete
    puts "All done!"
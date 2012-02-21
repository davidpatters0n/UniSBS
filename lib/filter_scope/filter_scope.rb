#module FilterScope 

#def self.include(base)
#  base.class_eval do 
#    scope :filter, lambda { |query, attributes|} # creates new scope to accept params. 
#    return if query.blank? 
    
#    collection = self #
    
#    attributes = collection.new.attributes unless attributes #Determines the attributes and what it should filter by. Uses all attributs in booking model
#    query.split(/\s/).each do |phrase|
#      conditions = [""] #Create emp
#      attributes.each do |attribute|
#        conditions[0] += attribute.to_s + " LIKE ? OR " 
#        conditions.push "%#{phrase}%" #Push conditions back to phrase param
#     end 
#      conditions[0] = conditions[0].sub(/ OR $/,"") #Regular expression so that if Cannock=1213 then 
#      collection = collection.where(conditions)
#      end
#      collection
#    }
#    end
#  end
#end

module FilterScope
  def self.included(base)
    base.class_eval do
      scope :filter, lambda { |query, attributes|
        return if query.blank?

        collection = self

        attributes = collection.new.attributes unless attributes
        query.split(/\s/).each do |phrase|
          conditions = [""]
          attributes.each do |attribute|
            conditions[0] += attribute.to_s + " LIKE ? OR "
            conditions.push "%#{phrase}%"
          end
          conditions[0] = conditions[0].sub(/ OR $/,"")
          collection = collection.where(conditions)
        end

        collection
      }
    end
  end
end
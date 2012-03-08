# This file should contain all the record creation needed to
# seed the database with its default values.
# The data can then be loaded with the
# rake db:seed (or created alongside the db with db:setup).

support_email = "sbs.support@dai.co.uk"

##########################################################
#
# Essential data seeding; for development and production
#
##########################################################
puts "Starting seeding " + Time.now.strftime( "%H:%M:%S" )

puts "Creating admin levels..."
local_admin = AdminLevel.find_or_create_by_name('local')
grant_local_admin = AdminLevel.find_or_create_by_name('local+grant')
global_admin = AdminLevel.find_or_create_by_name('global')

# The magic id for the internal company is 1, but it happens to be DHL
# DHL C-TMS Transport Management System "C-TMS"
internal_company = Company.find_by_id(1)
if internal_company.nil?
  puts "Creating internal company (DHL)..."
  internal_company = Company.create(:id => 1, :name => "DHL", :tms => "C-TMS" )
end

# Stobart GTS Transport Management System "GTS"
puts "Creating Eddie Stobart Ltd. (ESL)..."
Company.find_or_create_by_tms(:name => "ESL", :tms => "GTS")

# Great Bear Transport Management System "Great Bear"
puts "Creating Great Bear..."
Company.find_or_create_by_tms(:name => "GB", :tms => "Great Bear")

puts "Creating UNKNOWN placeholder company..."
Company.find_or_create_by_tms(:name => "Unknown", :tms => "UNKNOWN")

# User model does not allow mass-assignment so we don't use
# the usual find_or_create_by approach:
puts "Creating initial daisupport user #{support_email}..."
user = User.find_by_email(support_email)
user = User.new if user.nil?
user.email = support_email
user.admin_level = global_admin
user.company = internal_company
user.password = user.password_confirmation = "Clyde_01"
user.save!

puts "Creating slot length granularities..."
Granularity.construct_selection!([5, 10, 15, 20, 30, 40, 45, 60, 90, 120])

puts "Creating Sites..."
Site.names.each do |sitename|
  puts "   #{sitename}..."
  site = Site.find_or_initialize_by_name(sitename)
  site.update_attributes!(:past_days_to_keep => 7,
                  :days_in_advance => 7,
                  :provisional_bookings_expire_after => 60,
                  :granularity_id => Granularity.find_by_minutes(15).id)

  puts "      Creating Time Slot Capacities for #{sitename}"
  puts "         #{site.granularity.times}..."
  site.construct_initial_time_slot_capacities!
  puts "         ...#{site.time_slot_capacities.count} time slots"

  puts "      Creating Slot Days for #{sitename}..." 
  site.construct_days!
end

puts "Completed seeding " + Time.now.strftime( "%H:%M:%S" )
###########################################################

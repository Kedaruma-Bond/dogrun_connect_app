require 'rubygems'
require 'clockwork'
require './config/boot'
require './config/environment'

require './lib/jobs/togo_inu_shitsuke_hiroba_encount_generator_job.rb'
require './lib/jobs/force_exit_job.rb'
require './lib/jobs/guest_user_delete_job.rb'

module Clockwork
  handler do |job|
    job.call
  end

  every(5.minutes, TogoInuShitsukeHirobaEncountGeneratorJob.new, :thread => true)
  every(1.day, ForceExitJob.new, :at => '00:00')
  every(1.day, GuestUserDeleteJob.new, :at => '01:00')

end
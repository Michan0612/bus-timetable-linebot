Rails.application.routes.draw do
  post '/callback' => 'bus_timetable#callback'
end

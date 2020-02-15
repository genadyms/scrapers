require 'open-uri'
require 'nokogiri'
require 'byebug'

# total list vacancies
# url = 'https://career.habr.com/vacancies?currency=rur&type=all'

# ror remote sallary first page
url='https://career.habr.com/vacancies?skills%5B%5D=1080&currency=rur&remote=1'
# id="jobs_list_title"
html = open(url) { | result | result.read }
document = Nokogiri::HTML(html)
document.css('div.job').each do | job |
    link_description =job.css('a.job_icon')[0].attributes['href']
    puts link_description
end

puts jobs.length
require 'open-uri'
require 'nokogiri'
require 'byebug'


class Job
	def initialize(title, link, skills, salary)
		@title = title
		@link = link
		@skills = skills
		@salary = salary
	end

	def to_s
		"Title: #{@title}\r\nLink: #{@link}\r\nSkills: #{@skills}\r\nSalary: #{@salary}\r\n\r\n"
	end
end
# total list vacancies
# url = 'https://career.habr.com/vacancies?currency=rur&type=all'

# ror remote sallary first page
host = 'https://career.habr.com' 
url='https://career.habr.com/vacancies?skills%5B%5D=1080&currency=rur&remote=1'
# id="jobs_list_title"
html = open(url) { | result | result.read }
document = Nokogiri::HTML(html)
total_count = document.css('#jobs_list_title').text
data = []
document.css('div.job').each do | job |
	link = "#{ host }#{ job.css('a.job_icon')[0].attributes['href'].value }"
	title = job.css('div.info div.title a').text
    skills = job.css('div.skills a.skill').map { |el| el.children[0].text }
    salary = job.css('div.salary div.count').text
    job = Job.new title, link, skills, salary
    data << job
    puts job
end

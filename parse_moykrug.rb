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


@host = 'https://career.habr.com'

def create_jobs(document)
	data = []
	document.css('div.job').each do | job |
		link = "#{ @host }#{ job.css('a.job_icon')[0].attributes['href'].value }"
		title = job.css('div.info div.title a').text
	    skills = job.css('div.skills a.skill').map { |el| el.children[0].text }
	    salary = job.css('div.salary div.count').text
	    job = Job.new title, link, skills, salary
	    data << job
	    # puts job
	end
	data
end

def next_page(document)
  all_pages = document.css('a.page')
  current_page = document.css('a.page.current')
  all_pages = document.css('a.page')
  if all_pages.last.text != current_page.text
  	"#{@host}#{all_pages.last.attributes["href"].value}"
  end
end
# total list vacancies
# url = 'https://career.habr.com/vacancies?currency=rur&type=all'

# ror remote sallary first page 
url='https://career.habr.com/vacancies?skills%5B%5D=1080&currency=rur&remote=1'

html = open(url) { | result | result.read }
document = Nokogiri::HTML(html)
total_count = document.css('#jobs_list_title').text
next_page_link = next_page document
all_jobs = create_jobs(document)

while next_page_link
	html = open(next_page_link) { | result | result.read }
	document = Nokogiri::HTML(html)
	next_page_link = next_page document
    all_jobs << create_jobs(document)
end
puts all_jobs
puts "#{total_count} и пропаршено #{all_jobs.size}"
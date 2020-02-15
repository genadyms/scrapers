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

def get_document url
	Nokogiri::HTML open(url) { | result | result.read }
end


def parse(skill, url)
	total_count = ''
	all_jobs = []

	while url
		document = get_document url
		if total_count.empty?
			total_count = document.css('#jobs_list_title').text
		end
		url = false
		# url = next_page document
	 #    all_jobs << create_jobs(document)
	end

	# print jobs
	# puts all_jobs
	puts "#{skill} => #{total_count}, обработано #{all_jobs.size}"	
end
# total list vacancies
# url = 'https://career.habr.com/vacancies?currency=rur&type=all'

# ror remote sallary first page 
data_for_parse = {
	'RoR' => 'https://career.habr.com/vacancies?skills%5B%5D=1080&currency=rur&remote=1',
	'Django' => 'https://career.habr.com/vacancies?skills%5B%5D=1075&currency=rur&remote=1',
	'Flask' => 'https://career.habr.com/vacancies?skills%5B%5D=321&currency=rur&remote=1',
	'Laravel' => 'https://career.habr.com/vacancies?skills%5B%5D=109&currency=rur&remote=1',
	'Symfony' => 'https://career.habr.com/vacancies?skills%5B%5D=191&currency=rur&remote=1',
	'Yii' => 'https://career.habr.com/vacancies?skills%5B%5D=647&currency=rur&remote=1',
	# 'Angular' => '',
	# 'React' => '',
	# 'Nodejs' => '',
	'Java' => 'https://career.habr.com/vacancies?skills%5B%5D=1012&currency=rur&remote=1'
}

data_for_parse.each do | skill, url |
	parse skill, url
end
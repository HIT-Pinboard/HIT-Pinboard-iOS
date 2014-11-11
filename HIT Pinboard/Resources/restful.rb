#!/usr/bin/env ruby
require 'sinatra'
require 'JSON'

set :port, 8080
set :environment, :production

get '/' do
	"Hello RESTFul!"
end

get '/tagsList' do
	content_type :json
	return_message = {
		"status" => 200,
		"response" => [
			# tags here
			{
				"name" => "SME",
				"value" => "1",
				"children" => [{
					"name" => "SME - ANNO",
					"value" => "1.1",
					"children" => []
				},
				{
					"name" => "SME - NEWS",
					"value" => "1.2",
					"children" => []
				}]
			},
			{
				"name" => "JWC",
				"value" => "2",
				"children" => [{
					"name" => "JWC - ANNO",
					"value" => "2.1",
					"children" => []
				},
				{
					"name" => "JWC - NEWS",
					"value" => "2.2",
					"children" => []
				}]
			},
			{
				"name" => "STUACT",
				"value" => "3",
				"children" => []
			}
		]
	}
	return_message.to_json
end

post '/newsList' do
	content_type :json
	# data in this example is {"token"=>"eee", "data"=>["11", "22"]}
	# In Client, use this to test
	# response = RestClient.post 'http://localhost:8080/newsList', data, {:content_type => :json, :accept => :json}
	puts params#["token"] # this will print eee in console
	return_message = {
		"status" => 200,
		"response" => [
			{
				"title" => "假如明天我毕业――机电学院2012级年级大会成功举行",
				"url" => "/sme.hit.edu.cn/2014-09-23-news-1.json",
				"tags" => ["1.1", "3"],
				"date" => "2014-9-23 10:44:58",
			},
			{
				"title" => "机电学院2015级部分外校推免生面试成绩公告",
				"url" => "/sme.hit.edu.cn/2014-09-23-news-2.json",
				"tags" => ["1.2"],
				"date" => "2014-9-23 09:44:58",
			},
			{
				"title" => "机电工程学院召开班主任工作经验交流暨研讨会",
				"url" => "/sme.hit.edu.cn/2014-09-23-news-3.json",
				"tags" => ["1.2", "3"],
				"date" => "2014-9-23 07:44:58",
			}
		]
	}
	return_message.to_json
end
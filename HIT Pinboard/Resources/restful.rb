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
				"link" => "/sme.hit.edu.cn/2014-09-23-news-1.json",
				"tags" => ["1.1", "3"],
				"date" => "2014-9-23 10:44:58",
			},
			{
				"title" => "机电学院2015级部分外校推免生面试成绩公告",
				"link" => "/sme.hit.edu.cn/2014-09-23-news-2.json",
				"tags" => ["1.2"],
				"date" => "2014-9-23 09:44:58",
			},
			{
				"title" => "机电工程学院召开班主任工作经验交流暨研讨会",
				"link" => "/sme.hit.edu.cn/2014-09-23-news-3.json",
				"tags" => ["1.2", "3"],
				"date" => "2014-9-23 07:44:58",
			}
		]
	}
	return_message.to_json
end

get '/*/*.json' do
	content_type :json
	puts params[:splat]
	return_message = {
		"status" => 200,
		"response" => {
			"title" => "机电学院2015级部分外校推免生面试成绩公告",
		    "url" => "http://sme.hit.edu.cn/news/Show.asp?id=4559",
		    "date" => "2014-9-30 9:06:16 14:19:02",
		    "tags" => ["1.1", "3"],
		    "content" => "\\n\\n哈尔滨工业大学机电工程学院2014年秋季学期招生宣传活动――哈工程站宣讲会已经结束，现对部分推免生的面试成绩做如下公告：\\n\\n \\n\\n姓名    学校                   专业                               类型  成绩\\n裴智超 哈尔滨工程大学 机械设计制造及其自动化   推免   70\\n陈建烨 哈尔滨工程大学 机械设计制造及其自动化   推免   68\\n高春晓 哈尔滨工程大学 机械设计制造及其自动化   推免   71\\n黄   真 哈尔滨工程大学 机械设计制造及其自动化    推免   78\\n孙巨权 哈尔滨工程大学 机械设计制造及其自动化    推免   73\\n张   博 哈尔滨工程大学 机械设计制造及其自动化    推免   76\\n赵静璇 哈尔滨工程大学 工业设计（艺术类）          推免   78\\n宋   岩 哈尔滨工程大学 机械设计制造及其自动化    推免   75\\n范雪乔 哈尔滨工程大学 工业设计（艺术类）          推免   77\\n刘   启 哈尔滨工程大学 机械设计制造及其自动化    推免   75\\n袁儒鹏 哈尔滨工程大学 自动化                              推免  76\\n田丁盛 哈尔滨工程大学 机械设计制造及其自动化    推免  76\\n汪俊龙 哈尔滨工程大学 机械设计制造及其自动化    推免  69\\n姚兴华 哈尔滨工程大学 机械设计制造及其自动化    推免   73\\n谭荣凯 哈尔滨工程大学 机械设计制造及其自动化    推免   72\\n张   硕 哈尔滨工程大学 机械设计制造及其自动化    推免  73\\n李二洋 哈尔滨工程大学 机械设计制造及其自动化     推免 72\\n\\n \\n\\n请以上同学按时进入推免生系统进行网上报名，如有问题请联系86413811李老师。\\n\\n注：其他同学请关注后续成绩公告\\n\\n \\n\\n \\n\\n \\n\\n \\n\\n机电工程学院\\n\\n研究生办公室\\n\\n2014-9-25\\n\\n \\n\\n \\n\\n",
		    "imgs" => [

		    ]
		}
	}
	return_message.to_json
end
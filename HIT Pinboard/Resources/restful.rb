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
			"title" => "假如明天我毕业――机电学院2012级年级大会成功举行",
			"url" => "http://sme.hit.edu.cn/news/Show.asp?id=4557",
			"date" => "2014-9-23 10:44:58",
			"tags" => ["1.1", "3"],
			"content" => "\\n\\n\\n     （于文靖/文 张一丁/图）为了迎接新学期的到来，鼓励大家以更优的面貌投入到新学期的学习工作中去，9月21日18:00，机电学院2012级本科生在活动中心201召开以“假如明天我毕业”为主题的年级大会，大会由机电学院12级辅导员苏吉老师主持。\\n\\n\\n\\n       首先，苏吉老师引导大家设想“假如明天我毕业”，今天的我还有哪些遗憾和不足，现在的我们是否已经做好准备去迎接新的挑战，厉兵秣马，整装待发。如果大学生活即将结束，我们是否还有未曾完成的计划，还有未曾实现的梦想？如果有，那么剩下的这一年多大学时光我们将如何度过？\\n\\n\\n\\n       升入大三，许多同学对自己未来的发展方向存在疑问。为了让同学们对未来可选择的道路有更多了解，苏吉老师向大家介绍了往届毕业生的毕业去向，并告诉同学们，大三是目标确立的关键时期，每位同学都应该确定自己的目标，并为之做好准备。苏老师的话引发了同学们的深思。\\n\\n\\n\\n       随后，苏吉老师与大家分享了当今积极心理学领域很受大家认可的“幸福汉堡”模型理论，分别分析了“享乐主义型”、“忙碌奔波型”、“虚无主义型”和“感悟幸福型”四种不同的人生态度，全面深刻地剖析了在同学们中普遍存在的问题，并提出“习得性无助”概念，借以给予同学们警示，鼓励大家以积极乐观的心态面对接下来的学习生活，加强主观能动性，“逃离”困境。\\n\\n\\n\\n会上，苏吉老师期盼同学们珍惜“你还在的时候，拼命想要逃离；你离开的时候，却怎么也回不去”的学生时代；告诫大家要用心体会大学学习知识、参加活动的美好。苏老师希望大家珍惜时间，合理安排自己的时间。“你所浪费的今天，是昨天死去的人奢望的明天；你所厌恶的现在，是未来的你回不去的曾经。”\\n\\n\\n\\n       会后，同学们沉浸在深深的反思中，每个人都开始为自己的未来做着规划，并为之付出努力。\\n\\n\\n\\n#!-- Images[0] --!#\\n\\n\\n\\n#!-- Images[1] --!#\\n\\n\\n \\n\\n",
			"imgs" => [
				"http://sme.hit.edu.cn/news/UploadFile/image/20140923/20140923103935773577.jpg",
				"http://sme.hit.edu.cn/news/UploadFile/image/20140923/20140923104122582258.jpg"
			]
		}
	}
	return_message.to_json
end
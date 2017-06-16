# server.rb
require 'sinatra'
require 'sinatra/namespace'
require 'json'

set :port, 9494

def load_users
	file = File.read('users.json')
	users_data = JSON.parse(file)
	return users_data
end

def save_users(users_data)
	File.open('users.json', "w") do |f|
		f.write(users_data.to_json)
	end
end

namespace '/api/v1' do

	before do
		content_type 'application/json'
	end

	# listar clientes
	get '/clientes' do
		users_data = load_users
		users_data.to_json
	end

	# CRUD

	# R: Obtener un cliente
	get '/clientes/:id' do |user_id|
		users_data = load_users
		user_found = JSON.parse("{}")

		users_data.each do |user|
			if user["id"] == user_id.to_i
				user_found = user.to_json
				break
			end
		end

		user_found
	end

	# D: Eliminar un cliente
	delete '/clientes/:id' do |user_id|
		users_data = load_users

		users_data.each do |user|
			if user["id"] == user_id.to_i
				users_data.delete(user)
				save_users(users_data)
				break
			end
		end
		redirect '/clientes'
	end

	# C: Crear un cliente
	put '/clientes' do
		users_data = load_users

		user = JSON.parse(request.body.read)
		users_data.push(user)

		save_users(users_data)
	end

	# U: Actualizar un cliente
	post '/clientes/:id' do |user_id|
		users_data = load_users

		users_data.each do |user|
			if user["id"] == user_id.to_i
				new_user = JSON.parse(request.body.read)
				users_data.delete(user)
				users_data.push(new_user)
				save_users(users_data)
				break
			end
		end
	end
end

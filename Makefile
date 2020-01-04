setup:
	docker-compose run --rm --no-deps app sh -c "\
		mix deps.get \
		mix deps.clean \
		&& mix deps.compile"
	docker-compose run --rm app sh -c "\
		mix ecto.drop -r ForzaAssignment.Repo \
		&& mix ecto.create -r ForzaAssignment.Repo \
		&& mix ecto.migrate -r ForzaAssignment.Repo"

start:
	docker-compose up app
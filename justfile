test: test_

test_:
	nvim --headless -c "PlenaryBustedFile lua/github-util/init.test.lua"

watch:
	watchexec -w lua just test_

test: test_

test_:
	nvim --headless -c "PlenaryBustedFile lua/github-utils/init.test.lua"

watch:
	watchexec -w lua just test_

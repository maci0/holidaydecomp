UV ?= uv

.PHONY: check generate build compare clean

check:
	$(UV) sync --frozen
	$(UV) run --frozen ruff check tools
	$(UV) run --frozen python -m unittest discover -s tools -p 'test_*.py'
	$(UV) run --frozen python tools/check_publication.py

generate:
	$(UV) run --frozen python tools/gen_functions_json.py
	$(UV) run --frozen python tools/dfm_extract.py
	$(UV) run --frozen python tools/dfm_pack.py
	$(UV) run --frozen python tools/gen_pools.py
	$(UV) run --frozen python tools/gen_tables.py
	$(UV) run --frozen python tools/gen_data.py
	$(UV) run --frozen python tools/gen_tree.py
	cp templates/REACH.PAS src/main/REACH.PAS

build:
	./build.sh

compare:
	$(UV) run --frozen rebrew binary ne-compare bin/main/HOLIDAY.EXE --window 16

clean:
	rm -rf build bin output dist .scratch .rebrew .ruff_cache .pytest_cache
	find tools -type d -name __pycache__ -prune -exec rm -rf {} +
	find src/main -mindepth 1 -maxdepth 1 ! -name function_structure.json ! -name function_merges.toml -exec rm -rf {} +

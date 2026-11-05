UV ?= uv

.PHONY: check generate metadata status status-measure build compare clean

check:
	$(UV) sync --frozen
	$(UV) run --frozen ruff check tools
	$(UV) run --frozen python -m unittest discover -s tools -p 'test_*.py'
	$(UV) run --frozen python tools/gen_rebrew_functions.py --check
	$(UV) run --frozen python tools/gen_status.py --check

generate:
	$(UV) run --frozen python tools/gen_functions_json.py
	$(UV) run --frozen python tools/dfm_extract.py
	$(UV) run --frozen python tools/dfm_pack.py
	$(UV) run --frozen python tools/gen_pools.py
	$(UV) run --frozen python tools/gen_tables.py
	$(UV) run --frozen python tools/gen_data.py
	$(UV) run --frozen python tools/gen_tree.py
	cp templates/REACH.PAS src/main/REACH.PAS

metadata:
	$(UV) run --frozen python tools/gen_rebrew_functions.py

status:
	$(UV) run --frozen python tools/gen_status.py

status-measure:
	$(UV) run --frozen python tools/gen_status.py --measure

build:
	./build.sh

compare:
	$(UV) run --frozen rebrew binary ne-compare bin/main/HOLIDAY.EXE --window 16

clean:
	rm -rf build bin output dist .scratch .rebrew .ruff_cache .pytest_cache
	find tools -type d -name __pycache__ -prune -exec rm -rf {} +
	rm -rf src/main/forms src/main/HOLIDAY.RES src/main/.gen_tree_files
	rm -f src/main/DATAVAL.PAS src/main/POOLS.PAS src/main/TABLES.PAS

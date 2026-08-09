
ecoDB:
	@if [ -f .firstRunDone ]; then \
		FIRST_RUN=1 tempus -init scripts/run_session1.tcl -log logs/session1.log; \
	else \
		FIRST_RUN=0 tempus -init scripts/run_session1.tcl -log logs/session1.log; \
	fi
ecoFix: ecoDB
	@if [ -f .firstRunDone ]; then \
		FIRST_RUN=1 tempus -eco -init scripts/run_session2.tcl -log logs/session2.log; \
	else \
		FIRST_RUN=0 tempus -eco -init scripts/run_session2.tcl -log logs/session2.log; \
	fi

innovusFix: ecoFix
	@if [ -f .firstRunDone ]; then \
		FIRST_RUN=1 innovus -nowin -init scripts/run_PlaceAndRoute.tcl -log logs/PlaceAndRoute.log; \
	else \
		FIRST_RUN=0 innovus -nowin -init scripts/run_PlaceAndRoute.tcl -log logs/PlaceAndRoute.log; \
	fi
	touch .firstRunDone
staSignoff: innovusFix
	tempus -init scripts/run_session3.tcl -log logs/session3.log


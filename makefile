
VALAC=valac-0.28
VALAFILES=main.vala iso.vala iso_manager.vala display.vala etiquette.vala top_bar.vala new_iso_dialog.vala 
VALAPKGS= --pkg gtk+-3.0 --pkg gee-1.0 --pkg json-glib-1.0 --pkg posix --pkg libnotify
VALAOPTS=
EXEC=iso_manager

default:
	$(VALAC) $(VALAFILES) -o $(EXEC) $(VALAPKGS) $(VALAOPTS)

run:
	./$(EXEC)

clean:	
	rm $(EXEC)

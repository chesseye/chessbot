OCAMLBUILD= ocamlbuild \
		-no-links -classic-display \
		-tags debug,annot,thread

RMLBUILD= rmlbuild \
		-no-links -classic-display \
		-libs str \
		-tags debug,annot,thread

TARGET=native

all: chessbot

# controller: controller.rml.$(TARGET)
# 	cp _build/controller.rml.$(TARGET) controller

chessbot: chessbot.$(TARGET)
	cp _build/chessbot.$(TARGET) chessbot

chessbot.$(TARGET): wcs_message_t.ml wcs_message_t.mli wcs_message_j.ml wcs_message_j.mli FORCE
	$(OCAMLBUILD) -use-ocamlfind -pkg atdgen -pkg cohttp.lwt -pkg ppx_deriving_yojson chessbot.$(TARGET)

wcs_message_t.ml wcs_message_t.mli: wcs_message.atd
	atdgen -t wcs_message.atd

wcs_message_j.ml wcs_message_j.mli: wcs_message.atd
	atdgen -j -j-std wcs_message.atd


clean:
	ocamlbuild -clean
	rm -f wcs_message_t.ml wcs_message_t.mli wcs_message_j.ml wcs_message_j.mli

realclean: clean
	rm -f *~ chessbot

cleanall: realclean

FORCE:

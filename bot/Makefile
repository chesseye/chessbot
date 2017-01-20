CHESSEYE_DIR=../../../chesseye/controller

OCAMLBUILD= ocamlbuild \
		-no-links -classic-display \
		-tags debug,annot,thread

RMLBUILD= rmlbuild \
		-rmlc "rmlc -I $(CHESSEYE_DIR)/_build" \
		-no-links -classic-display \
		-tags debug,annot,thread \
		-cflags "-I","$(CHESSEYE_DIR)/_build" \
		-lflags "-thread","threads.cmxa" \
		-lflags "-I","`rmlc -where`","rmllib.cmxa" \
		-lflags "-I","$(CHESSEYE_DIR)/_build" \
		-lflags "$(CHESSEYE_DIR)/_build/config.cmx" \
		-lflags "$(CHESSEYE_DIR)/_build/ochess.cmx" \
		-lflags "$(CHESSEYE_DIR)/_build/fen.cmx" \
		-lflags "$(CHESSEYE_DIR)/_build/util.cmx" \
		-lflags "$(CHESSEYE_DIR)/_build/dmov_map.cmx" \
		-lflags "$(CHESSEYE_DIR)/_build/bridge.cmx" \
		-lflags "$(CHESSEYE_DIR)/_build/controller_core.cmx"

TARGET=native

all: bot

# controller: controller.rml.$(TARGET)
# 	cp _build/controller.rml.$(TARGET) controller

bot: bot.$(TARGET)
	cp _build/bot.$(TARGET) bot

bot.$(TARGET): wcs_message_t.mli wcs_message_j.mli context_types_t.mli context_types_j.mli FORCE
	$(RMLBUILD) -use-ocamlfind -pkg atdgen -pkg cohttp.lwt -pkg ppx_deriving_yojson bot.$(TARGET)

wcs_message_t.ml wcs_message_t.mli: wcs_message.atd
	atdgen -t wcs_message.atd

wcs_message_j.ml wcs_message_j.mli: wcs_message.atd
	atdgen -j -j-std wcs_message.atd

context_types_t.ml context_types_t.mli: context_types.atd
	atdgen -t context_types.atd

context_types_j.ml context_types_j.mli: context_types.atd
	atdgen -j -j-std context_types.atd


clean:
	ocamlbuild -clean
	rm -f wcs_message_t.ml wcs_message_t.mli \
		wcs_message_j.ml wcs_message_j.mli \
		context_types_t.ml context_types_t.mli \
		context_types_j.ml context_types_j.mli

realclean: clean
	rm -f *~ bot

cleanall: realclean

FORCE:

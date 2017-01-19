OCAMLBUILD= ocamlbuild \
		-no-links -classic-display \
		-tags debug,annot,thread

RMLBUILD= rmlbuild \
		-no-links -classic-display \
		-tags debug,annot,thread

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

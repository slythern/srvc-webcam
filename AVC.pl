:- ensure_loaded(library(util/arity32)).
:- use_module(library(http/http_open)).
:- ensure_loaded(library(xpath)).

:- verbosity(all).

avc_jpg_download :-
  get_time(GET_TIME),
  format_time(atom(DATETIME),'%F %p %H%M',GET_TIME),
  atomic_list_concat(['alpine_visitor_center ',DATETIME,'.jpg'],OUT_FILENAME),
  status(starting_http_reading_pass(OUT_FILENAME),display),
  http_open('https://www.nps.gov/webcams-romo/alpine_visitor_center.jpg', InStream, [close_on_abort(true),type(binary)]),
  status('http open for reading',progress),
  open(OUT_FILENAME,write,OutStream,[close_on_abort(true),type(binary)]),
  status('output open for writing',progress),
  copy_stream_data(InStream,OutStream),
  close(InStream),
  close(OutStream),
  status('download complete and streams closed',progress),
  !,
  nop.
  
avc_jpg_download :-
  status(not_available,info).


main :-
  verbosity(all),
%  ignore((current_prolog_flag(log_options,[]),verbosity(3))),
  status('> starting AVC',entry),
  avc_jpg_download,
  !,
  status(success,info),
  ignore(
    ( current_prolog_flag(executable, EXE),
      sub_atom(EXE,_B,_L,0,'avc.exe'),
      beep,
      status('> done, sleeping for 10 seconds before halt.',display),
      logfile(close),
      sleep(10),
      halt
    )
  ),
  logfile(close).


:- status(avc_loaded,info).

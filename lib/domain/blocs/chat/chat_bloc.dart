import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:hellogram/data/env/env.dart';
import 'package:hellogram/data/storage/secure_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  late IO.Socket _socket;

  ChatBloc() : super(const ChatInitial()) {
    on<OnIsWrittingEvent>(_isWritting);
    on<OnEmitMessageEvent>(_emitMessages);
    on<OnListenMessageEvent>(_listenMessageEvent);
  }

  void initSocketChat() async {
    final token = await secureStorage.readToken();
    _socket = IO.io('http://192.168.10.219:7070/socket-chat-message', {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {'xxx-token': token}
    });
    _socket.connect();

    _socket.on('message-personal', (data) {
      add(OnListenMessageEvent(data['from'], data['to'], data['message']));
    });
  }

  void disconnectSocketMessagePersonal() {
    _socket.off('message-personal');
  }

  void disconnectSocket() {
    _socket.disconnect();
  }

  Future<void> _isWritting(
      OnIsWrittingEvent event, Emitter<ChatState> emit) async {
    emit(ChatSetIsWrittingState(writting: event.isWritting));
  }

  Future<void> _emitMessages(
      OnEmitMessageEvent event, Emitter<ChatState> emit) async {
    _socket.emit('message-personal', {
      'from': event.uidSource,
      'to': event.uidUserTarget,
      'message': event.message
    });
  }

  Future<void> _listenMessageEvent(
      OnListenMessageEvent event, Emitter<ChatState> emit) async {
    emit(ChatListengMessageState(
        uidFrom: event.uidFrom, uidTo: event.uidTo, messages: event.messages));
  }
}

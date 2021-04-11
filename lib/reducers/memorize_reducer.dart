

import 'package:booksmart/actions/memorize_action.dart';
import 'package:booksmart/states/app_state.dart';
import 'package:booksmart/states/memorize_state.dart';

AppState memorizeReducer(AppState state, dynamic action) {
  if (action is SetMemorizeStateAction) {
    MemorizeState memorizeState = state.memorizeState;
    memorizeState.rememberedCount = action.payload != null ? action.payload.rememberedCount : memorizeState.rememberedCount;
    memorizeState.reviewCount = action.payload != null ? action.payload.reviewCount : memorizeState.reviewCount;
    state.memorizeState = memorizeState;
    return state;
  } else {
    return state;
  }
}
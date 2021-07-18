abstract class UpdateOrderStates {}

class LoadingOrderData extends UpdateOrderStates {}

class LoadedOrderData extends UpdateOrderStates {}

class ErrorOrderData extends UpdateOrderStates {
  final String error;

  ErrorOrderData(this.error);
}

class ChangePaymentMethod extends UpdateOrderStates {}

class ToggleServiceSelected extends UpdateOrderStates {}

class UpdatingOrder extends UpdateOrderStates {}

class UpdatedOrder extends UpdateOrderStates {}

class NoSelectedServices extends UpdateOrderStates {}

class ErrorUpdateOrder extends UpdateOrderStates {
  final String error;

  ErrorUpdateOrder(this.error);
}
class ChangeQuantityProduct extends UpdateOrderStates{}
class RemoveProduct extends UpdateOrderStates{}

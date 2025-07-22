enum BillType {
  purchaseOrder(5),
  purchaseInvoice(1),
  salesOrder(6),
  salesInvoice(2),
  //vendor-payment
  paymentMade(3),
  //client-payment
  paymentReceived(4);

  final int choice;
  const BillType(this.choice);
}

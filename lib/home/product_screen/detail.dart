import 'package:flutter/material.dart';
import 'package:hwn_mart/widgets/const.dart';

class DetailScreen extends StatelessWidget {
  final availab, price, sku, color, size, vendor, category, other;
  DetailScreen(this.availab, this.price, this.sku, this.color, this.size,
      this.vendor, this.category, this.other);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Container(
          child: Table(
            border: TableBorder.all(color: Colors.grey[300]),
            children: [
              TableRow(
                children: [
                  TableRowHeading(
                    "Price",
                  ),
                  TableRowDetail(
                    "$price",
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableRowHeading(
                    "Vendor",
                  ),
                  TableRowDetail(
                    "$vendor",
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableRowHeading(
                    "SKU",
                  ),
                  TableRowDetail(
                    "$sku",
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableRowHeading(
                    "Available",
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        "$availab",
                        style: TextStyle(
                          fontSize: 16,
                          color: availab.toString().toLowerCase() == "in stock"
                              ? Colors.green
                              : primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableRowHeading(
                    "Color",
                  ),
                  TableRowDetail(
                    color == null || color == "null" || color == ""
                        ? ""
                        : "$color",
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableRowHeading(
                    "Sizes",
                  ),
                  TableRowDetail(
                    size == null || size == "null" || size == "" ? "None" : "$size",
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableRowHeading(
                    "Others",
                  ),
                  TableRowDetail(
                    "$other",
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableRowHeading(
                    "Categories",
                  ),
                  TableRowDetail(
                    "$category",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TableRowHeading extends StatelessWidget {
  final title;
  TableRowHeading(this.title);
  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          "$title",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class TableRowDetail extends StatelessWidget {
  final subtitle;
  TableRowDetail(this.subtitle);
  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          "$subtitle",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

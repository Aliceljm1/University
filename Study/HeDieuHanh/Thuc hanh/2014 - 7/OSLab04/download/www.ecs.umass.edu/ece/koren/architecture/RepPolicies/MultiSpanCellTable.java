/*
 * (swing1.1beta3)
 *
 */

//package jp.gr.java_conf.tame.swing.table;

import java.util.*;
import java.awt.*;
import javax.swing.*;
import javax.swing.table.*;
import javax.swing.plaf.basic.*;
import javax.swing.event.*;


/**
 * @version 1.0 11/26/98
 */

public class MultiSpanCellTable extends JTable {

  public MultiSpanCellTable(TableModel model) {
    super(model);
    setUI(new MultiSpanCellTableUI());
    getTableHeader().setReorderingAllowed(false);
    setCellSelectionEnabled(true);
    setSelectionMode(ListSelectionModel.SINGLE_INTERVAL_SELECTION);
  }


  public Rectangle getCellRect(int row, int column, boolean includeSpacing) {
    Rectangle sRect = super.getCellRect(row,column,includeSpacing);
    if ((row <0) || (column<0) ||
        (getRowCount() <= row) || (getColumnCount() <= column)) {
        return sRect;
    }
    CellSpan cellAtt = (CellSpan)((AttributiveCellTableModel)getModel()).getCellAttribute();
    if (! cellAtt.isVisible(row,column)) {
      int temp_row    = row;
      int temp_column = column;
      row    += cellAtt.getSpan(temp_row,temp_column)[CellSpan.ROW];
      column += cellAtt.getSpan(temp_row,temp_column)[CellSpan.COLUMN];
    }
    int[] n = cellAtt.getSpan(row,column);

    int index = 0;
    int columnMargin = getColumnModel().getColumnMargin();
    Rectangle cellFrame = new Rectangle();
    int aCellHeight = rowHeight + rowMargin;
    cellFrame.y = row * aCellHeight;
    cellFrame.height = n[CellSpan.ROW] * aCellHeight;

    Enumeration enumeration = getColumnModel().getColumns();
    while (enumeration.hasMoreElements()) {
      TableColumn aColumn = (TableColumn)enumeration.nextElement();
      cellFrame.width = aColumn.getWidth() + columnMargin;
      if (index == column) break;
      cellFrame.x += cellFrame.width;
      index++;
    }
    for (int i=0;i< n[CellSpan.COLUMN]-1;i++) {
      TableColumn aColumn = (TableColumn)enumeration.nextElement();
      cellFrame.width += aColumn.getWidth() + columnMargin;
    }



    if (!includeSpacing) {
      Dimension spacing = getIntercellSpacing();
      cellFrame.setBounds(cellFrame.x +      spacing.width/2,
			  cellFrame.y +      spacing.height/2,
			  cellFrame.width -  spacing.width,
			  cellFrame.height - spacing.height);
    }
    return cellFrame;
  }


  private int[] rowColumnAtPoint(Point point) {
    int[] retValue = {-1,-1};
    int row = point.y / (rowHeight + rowMargin);
    if ((row <0)||(getRowCount() <= row)) return retValue;
    int column = getColumnModel().getColumnIndexAtX(point.x);

    CellSpan cellAtt = (CellSpan)((AttributiveCellTableModel)getModel()).getCellAttribute();

    if (cellAtt.isVisible(row,column)) {
      retValue[CellSpan.COLUMN] = column;
      retValue[CellSpan.ROW   ] = row;
      return retValue;
    }
    retValue[CellSpan.COLUMN] = column + cellAtt.getSpan(row,column)[CellSpan.COLUMN];
    retValue[CellSpan.ROW   ] = row + cellAtt.getSpan(row,column)[CellSpan.ROW];
    return retValue;
  }


  public int rowAtPoint(Point point) {
    return rowColumnAtPoint(point)[CellSpan.ROW];
  }
  public int columnAtPoint(Point point) {
    return rowColumnAtPoint(point)[CellSpan.COLUMN];
  }



  public void columnSelectionChanged(ListSelectionEvent e) {
    repaint();
  }

  public void valueChanged(ListSelectionEvent e) {
    int firstIndex = e.getFirstIndex();
    int  lastIndex = e.getLastIndex();
    if (firstIndex == -1 && lastIndex == -1) { // Selection cleared.
      repaint();
    }
    Rectangle dirtyRegion = getCellRect(firstIndex, 0, false);
    int numCoumns = getColumnCount();
    int index = firstIndex;
    for (int i=0;i<numCoumns;i++) {
      dirtyRegion.add(getCellRect(index, i, false));
    }
    index = lastIndex;
    for (int i=0;i<numCoumns;i++) {
      dirtyRegion.add(getCellRect(index, i, false));
    }
    repaint(dirtyRegion.x, dirtyRegion.y, dirtyRegion.width, dirtyRegion.height);
  }

}


/*
 * (swing1.1beta3)
 *
 */

//package jp.gr.java_conf.tame.swing.table;

import java.awt.*;


/**
 * @version 1.0 11/22/98
 */

public interface ColoredCell {

  public Color getForeground(int row, int column);
  public void setForeground(Color color, int row, int column);
  public void setForeground(Color color, int[] rows, int[] columns);

  public Color getBackground(int row, int column);
  public void setBackground(Color color, int row, int column);
  public void setBackground(Color color, int[] rows, int[] columns);


}

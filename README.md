# QLMutilTableView

一个多表的实现方式

# 博客地址:https://www.jianshu.com/p/589fcc1d22b9

需要达到的效果：
1、左右滑动时，保证第一列固定不动，右侧的列表可以根据手势进行左右滑动；
2、当左右滑动自然减速到0时，需要根据最后一列在屏幕中的显示情况，决定这一列是否需要进行自动位置矫正，以便完整的显示某一列；
3、上线滑动时，整个列表都进行上线滑动，保证列表滑动的流畅性；
4、表格的数据刷新和单元格的显示，提供和系统相一致的方法；
5、表头部分支持可配置的点击事件；

import 'dart:core';

/// A*算法类
class DFAStar {
  static const int BAR = 1;  // 障碍
  static const int PATH = 2; // 路径
  static const int DIRECT_VALUE = 10; // 横竖移动代价
  static const int OBLIQUE_VALUE = 14; // 斜移动代价

  List<DFNode> openList = [];
  List<DFNode> closeList = [];
  List<DFCoord> pathList = [];

  /// 开始算法
  void start(DFMap map) {
    /// clean
    openList.clear();
    closeList.clear();
    pathList.clear();
    /// 开始搜索
    openList.add(map.start);
    /// 优先队列(升序)
    openList.sort((a, b) => a.compareTo(b));
    moveNodes(map);
  }

  /// 移动当前结点
  void moveNodes(DFMap map) {
    while (openList.length > 0) {
      /// 第一个元素
      DFNode current = openList.removeAt(0);
      closeList.add(current);
      addNeighborNodeInOpen(map, current);
      if (isCoordInClose(map.end.coord)) {
        drawPath(map.maps, map.end);
        break;
      }
    }
  }

  /// 在二维数组中绘制路径
  void drawPath(List<List<int>>? maps, DFNode? end) {
    if (end == null || maps == null) return;
    print("总代价：" + end.G.toString());
    while (end != null) {
      DFCoord c = end.coord!;
      maps[c.y][c.x] = PATH;
      end = end.parent;
      pathList.add(DFCoord(c.x, c.y));
    }
  }

  /// 添加所有邻结点到open表
  void addNeighborNodeInOpen(DFMap mapInfo, DFNode current) {
    int x = current.coord!.x;
    int y = current.coord!.y;
    // 左
    addNeighborNodeInOpenXy(mapInfo, current, x - 1, y, DIRECT_VALUE);
    // 上
    addNeighborNodeInOpenXy(mapInfo, current, x, y - 1, DIRECT_VALUE);
    // 右
    addNeighborNodeInOpenXy(mapInfo, current, x + 1, y, DIRECT_VALUE);
    // 下
    addNeighborNodeInOpenXy(mapInfo, current, x, y + 1, DIRECT_VALUE);
    // 左上
    addNeighborNodeInOpenXy(mapInfo, current, x - 1, y - 1, OBLIQUE_VALUE);
    // 右上
    addNeighborNodeInOpenXy(mapInfo, current, x + 1, y - 1, OBLIQUE_VALUE);
    // 右下
    addNeighborNodeInOpenXy(mapInfo, current, x + 1, y + 1, OBLIQUE_VALUE);
    // 左下
    addNeighborNodeInOpenXy(mapInfo, current, x - 1, y + 1, OBLIQUE_VALUE);
  }

  /// 添加一个邻结点到open表
  void addNeighborNodeInOpenXy(DFMap mapInfo, DFNode current, int x, int y, int value) {
    if (canAddNodeToOpen(mapInfo, x, y)) {
      DFNode end = mapInfo.end;
      DFCoord coord = DFCoord(x, y);
      int G = current.G + value; // 计算邻结点的G值
      DFNode? child = findNodeInOpen(coord);
      if (child == null) {
        int H = calcH(end.coord!, coord); // 计算H值
        if (isEndNode(end.coord!, coord)) {
          child = end;
          child.parent = current;
          child.G = G;
          child.H = H;
        } else {
          child = DFNode.newNode(coord, current, G, H);
        }
        openList.add(child);
        openList.sort((a, b) => a.compareTo(b));
      } else if (child.G > G) {
        child.G = G;
        child.parent = current;
        openList.add(child);
        openList.sort((a, b) => a.compareTo(b));
      }
    }
  }

  /// 从Open列表中查找结点
  DFNode? findNodeInOpen(DFCoord? coord) {
    if (coord == null || openList.length == 0) return null;
    for (DFNode node in openList) {
      if (node.coord! == coord) {
        return node;
      }
    }
    return null;
  }

  /// 计算H的估值：“曼哈顿”法，坐标分别取差值相加
  int calcH(DFCoord end, DFCoord coord) {
    return ((end.x - coord.x).abs() + (end.y - coord.y).abs()) * DIRECT_VALUE;
  }

  /// 判断结点是否是最终结点
  bool isEndNode(DFCoord end, DFCoord? coord) {
    return coord != null && end == coord;
  }

  /// 判断结点能否放入Open列表
  bool canAddNodeToOpen(DFMap mapInfo, int x, int y) {
    /// 是否在地图中
    if (x < 0 || x >= mapInfo.width || y < 0 || y >= mapInfo.height) return false;

    /// 判断是否是不可通过的结点
    if (mapInfo.maps![y][x] == BAR) return false;

    /// 判断结点是否存在close表
    if (isCoordInCloseXy(x, y)) return false;

    return true;
  }

  /// 判断坐标是否在close表中
  bool isCoordInClose(DFCoord? coord) {
    if (coord == null) {
      return false;
    }
    return isCoordInCloseXy(coord.x, coord.y);
  }

  /// 判断坐标是否在close表中
  bool isCoordInCloseXy(int x, int y) {
    if (closeList.length == 0) {
      return false;
    }
    for (DFNode node in closeList) {
      if (node.coord!.x == x && node.coord!.y == y) {
        return true;
      }
    }
    return false;
  }
}

/// 包含地图所需的所有输入数据
class DFMap {
  List<List<int>>? maps; /// 二维数组的地图
  int width; /// 地图的宽
  int height; /// 地图的高
  DFNode start; /// 起始结点
  DFNode end; /// 最终结点

  DFMap(this.maps, this.width, this.height, this.start, this.end);
}

/// 路径节点
class DFNode {
  DFCoord? coord; // 坐标
  DFNode? parent; // 父结点
  int G = 0; // G：是个准确的值，是起点到当前结点的代价
  int H = 0; // H：是个估值，当前结点到目的结点的估计代价

  DFNode(int x, int y) {
    this.coord = new DFCoord(x, y);
  }

  static DFNode newNode(DFCoord coord, DFNode parent, int g, int h) {
    DFNode node = DFNode(0, 0);
    node.coord = coord;
    node.parent = parent;
    node.G = g;
    node.H = h;
    return node;
  }

  @override
  String toString() {
    return coord.toString();
  }

  /// 排序比较
  int compareTo(DFNode other) {
    /// 大于
    if (G + H > other.G + other.H) {
      return 1;
    }
    /// 小于
    else if (G + H < other.G + other.H) {
      return -1;
    }
    /// 等于
    return 0;
  }
}

/// 坐标
class DFCoord {
  int x;
  int y;

  DFCoord(this.x, this.y);

  @override
  bool operator ==(Object other) {
    if (other is DFCoord) {
      return x == other.x && y == other.y;
    }
    return false;
  }

  @override
  String toString() {
    return "x:" + x.toString() + ",y:" + y.toString();
  }
}

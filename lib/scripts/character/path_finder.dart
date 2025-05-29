import 'package:flame/components.dart';

class PathNode {
  final Vector2 position;
  double gCost = 0; // Cost from start
  double hCost = 0; // Estimated cost to end
  PathNode? parent;

  PathNode(this.position);

  double get fCost => gCost + hCost;
}

class PathFinder {
  final List<Vector2> obstacles;
  final Vector2 gridSize;
  final double nodeSize;

  PathFinder({
    required this.obstacles,
    required this.gridSize,
    this.nodeSize = 32.0, // Default node size (can be adjusted based on game scale)
  });

  List<Vector2> findPath(Vector2 start, Vector2 end) {
    var startNode = PathNode(start);
    var endNode = PathNode(end);

    var openSet = <PathNode>[startNode];
    var closedSet = <PathNode>[];

    while (openSet.isNotEmpty) {
      var currentNode = openSet.reduce((a, b) => a.fCost < b.fCost ? a : b);

      if (_vectorsEqual(currentNode.position, endNode.position)) {
        return _retracePath(startNode, currentNode);
      }

      openSet.remove(currentNode);
      closedSet.add(currentNode);

      for (var neighbor in _getNeighbors(currentNode)) {
        if (closedSet.any((n) => _vectorsEqual(n.position, neighbor.position))) {
          continue;
        }

        double newCostToNeighbor = currentNode.gCost + 
            _getDistance(currentNode.position, neighbor.position);

        if (newCostToNeighbor < neighbor.gCost || 
            !openSet.any((n) => _vectorsEqual(n.position, neighbor.position))) {
          neighbor.gCost = newCostToNeighbor;
          neighbor.hCost = _getDistance(neighbor.position, endNode.position);
          neighbor.parent = currentNode;

          if (!openSet.any((n) => _vectorsEqual(n.position, neighbor.position))) {
            openSet.add(neighbor);
          }
        }
      }
    }

    return []; // No path found
  }

  List<PathNode> _getNeighbors(PathNode node) {
    var neighbors = <PathNode>[];
    var directions = [
      Vector2(-1, 0), Vector2(1, 0),  // Left, Right
      Vector2(0, -1), Vector2(0, 1),  // Up, Down
      Vector2(-1, -1), Vector2(-1, 1),  // Diagonals
      Vector2(1, -1), Vector2(1, 1),
    ];

    for (var dir in directions) {
      var neighborPos = node.position + (dir * nodeSize);
      
      // Check bounds
      if (neighborPos.x < 0 || neighborPos.x > gridSize.x ||
          neighborPos.y < 0 || neighborPos.y > gridSize.y) {
        continue;
      }

      // Check obstacles
      if (obstacles.any((obs) => 
          (obs - neighborPos).length < nodeSize)) {
        continue;
      }

      neighbors.add(PathNode(neighborPos));
    }

    return neighbors;
  }

  double _getDistance(Vector2 a, Vector2 b) {
    var dx = (a.x - b.x).abs();
    var dy = (a.y - b.y).abs();
    return dx > dy ? dx : dy;
  }

  bool _vectorsEqual(Vector2 a, Vector2 b) {
    return (a - b).length < 0.001;
  }

  List<Vector2> _retracePath(PathNode startNode, PathNode endNode) {
    var path = <Vector2>[];
    var currentNode = endNode;

    while (!_vectorsEqual(currentNode.position, startNode.position)) {
      path.add(currentNode.position);
      currentNode = currentNode.parent!;
    }

    path.add(startNode.position);
    path = path.reversed.toList();

    return _smoothPath(path);
  }

  List<Vector2> _smoothPath(List<Vector2> path) {
    if (path.length <= 2) return path;

    var smoothed = <Vector2>[path.first];
    var current = 1;

    while (current < path.length - 1) {
      var direction = path[current + 1] - path[current - 1];
      if (direction.length > nodeSize * 2) {
        smoothed.add(path[current]);
      }
      current++;
    }

    smoothed.add(path.last);
    return smoothed;
  }
}

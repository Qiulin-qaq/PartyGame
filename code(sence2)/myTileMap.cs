using Godot;
using System;

public partial class myTileMap : TileMap
{
    private PackedScene scene;

    public override void _Ready()
    {
        // 加载待复用的场景
        var scene = GD.Load<PackedScene>("res://MyScene.tscn");

        // 创建多个实例并放置在指定位置
        for (int i = 0; i < 5; i++)
        {
            Node2D instance = (Node2D)scene.Instantiate(); // 实例化场景
            instance.Position = new Vector2(i * 100, 100); // 设置位置
            AddChild(instance); // 将实例添加到主场景中
        }
    }
}

using Godot;
using System;

public partial class myScene2 : Node2D
{
    private PackedScene _scene;

    public override void _Ready()
    {
        // 加载待复用的场景
        _scene = GD.Load<PackedScene>("res://fire.tscn");

        // 检查场景是否成功加载
        if (_scene == null)
        {
            GD.PrintErr("Failed to load scene 'res://fire.tscn'");
            return;
        }

        // 创建多个实例并放置在指定位置
        for (int i = 0; i < 5; i++)
        {
            Node2D instance = (Node2D)_scene.Instantiate(); // 实例化场景
            instance.Position = new Vector2(i * 100, 100); // 设置位置
            AddChild(instance); // 将实例添加到主场景中
        }

        GD.Print("Instances created and added to the scene.");
    }
}


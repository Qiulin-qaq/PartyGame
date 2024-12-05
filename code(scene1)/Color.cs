using Godot;
using System;

public partial class Color : Area2D
{
	private Sprite2D Sprite;
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		//将轨迹放入track组中，使得角色能消除所有轨迹
		base._Ready();
		AddToGroup("track");
		//获取Sprite节点
		Sprite=GetNode<Sprite2D>("Sprite2D");


		// 禁用碰撞，防止生成后立即判定
		CollisionShape2D shape = GetNode<CollisionShape2D>("CollisionShape2D");
		shape.Disabled = true;
		// 延迟启用碰撞
		GetTree().CreateTimer(0.3f).Timeout += () => {
		shape.Disabled = false; // 启用碰撞
	};
	}

	public void ChangeTileColor(){
		GD.Print("变色");

		//在角色经过的地方加载场景，达到变色的效果
		var spaces = GetTree().GetNodesInGroup("players"); // 假设角色组名为 "players"

		foreach (Node player in spaces)
		{
			if (player is CharacterBody2D character)
			{
				GD.Print("判定成功，执行操作");

				character.Call("ChangeTileColor");
			}
		}
		//不删除节点
	}

	//检测与player组的碰撞
	public void OnBodyEntered(Node body)
	{
		//等待
		//await ToSignal(GetTree().CreateTimer(1.0f), "timeout");
		if (body.IsInGroup("players"))
		{
			GD.Print("角色进入轨迹，移除轨迹");
			body.Call("RemoveColorInstance"); // 调用角色方法减少计数
			QueueFree(); // 移除自身
		}
	}
}

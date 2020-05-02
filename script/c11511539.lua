--Vortex Weaponry
function c11511539.initial_effect(c)
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsSetCard,0xffa))
	--Atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(c11511539.fcon)
	e1:SetValue(700)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetLabel(RACE_PLANT+RACE_INSECT+RACE_AQUA+RACE_DINOSAUR+RACE_FISH+RACE_SEASERPENT+RACE_ROCK)
	e2:SetCondition(c11511539.con)
	e2:SetValue(c11511539.efilter)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetLabel(RACE_FAIRY+RACE_PYRO+RACE_DRAGON+RACE_THUNDER+RACE_PSYCHO+RACE_WYRM+RACE_REPTILE)
	e3:SetCondition(c11511539.con)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	--Atk
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetLabel(0xffffff-e2:GetLabel()-e3:GetLabel())
	e5:SetCondition(c11511539.con)
	e5:SetValue(1000)
	c:RegisterEffect(e5)
end
function c11511539.con(e)
	return e:GetHandler():GetEquipTarget():IsRace(e:GetLabel())
end
function c11511539.fcon(e)
	return e:GetHandler():GetEquipTarget():IsType(TYPE_FUSION)
end
function c11511539.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end

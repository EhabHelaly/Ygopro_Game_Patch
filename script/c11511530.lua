--Vortex Despair
function c11511530.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,11511529,aux.FilterBoolFunction(c11511530.filterF),1,true)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c11511530.value)
	c:RegisterEffect(e1)
end
function c11511530.filterF(c)
	return c:IsFusionSetCard(0xffa) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c11511530.filter(c)
	return c:IsSetCard(0xffa) and c:IsFaceup()
end
function c11511530.value(e)
	local g=Duel.GetMatchingGroup(c11511530.filter,e:GetHandler():GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetRace)*200
end

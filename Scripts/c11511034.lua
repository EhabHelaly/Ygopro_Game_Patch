--Elegantea Annihilator Zephyr
function c11511034.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xff),9,2)
	c:EnableReviveLimit()
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c11511034.con)
	e1:SetTargetRange(0,1)
	e1:SetValue(c11511034.aclimit)
	c:RegisterEffect(e1)
	--atk up atk all
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c11511034.cost)
	e2:SetOperation(c11511034.op)
	c:RegisterEffect(e2)
end
function c11511034.con(e)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_BATTLE or ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL
end
function c11511034.aclimit(e,re,tp)
	return (re:IsActiveType(TYPE_MONSTER)or re:GetHandler():IsType(TYPE_SPELL) or re:GetHandler():IsType(TYPE_TRAP) ) and not re:GetHandler():IsImmuneToEffect(e)
end
function c11511034.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c11511034.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
    	local e2=e1:Clone()
		e2:SetCode(EFFECT_ATTACK_ALL)
		e2:SetValue(1)
		c:RegisterEffect(e2)
	end
end

--Dragonilian Vanroy
function c11511229.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroProcedure2(c,aux.FilterBoolFunction(c11511229.filterS,ATTRIBUTE_WATER),aux.NonTuner(c11511229.filterS,ATTRIBUTE_WIND))
	aux.AddSynchroProcedure2(c,aux.FilterBoolFunction(c11511229.filterS,ATTRIBUTE_WIND),aux.NonTuner(c11511229.filterS,ATTRIBUTE_WATER))
	-- add counter
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c11511229.target)
	e1:SetOperation(c11511229.operation)
	c:RegisterEffect(e1)

end
function c11511229.filterS(c,att)
	return c:IsSetCard(0xffd) and c:IsAttribute(att) 
end
function c11511229.filterC(c)
	return c:IsSetCard(0xffd) and c:IsType(TYPE_MONSTER) and c:IsCanAddCounter(0xffd,1)
end
function c11511229.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c11511229.filterC,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,tp,0)
end
function c11511229.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c11511229.filterC,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		g:GetFirst():AddCounter(0xffd,1)
	end
end

--Elegantea Shogan Hazel
function c11511028.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xfff),5,2)
	c:EnableReviveLimit()
	--synchro xyz
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c11511028.tg)
	e1:SetOperation(c11511028.op)
	c:RegisterEffect(e1)
end
function c11511028.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local opt=Duel.SelectOption(tp,aux.Stringid(11511028,0),aux.Stringid(11511028,1))
    e:SetLabel(opt)
end
function c11511028.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local x=e:GetLabel()
    --Immune
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetLabel(x)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetValue(c11511028.filterim)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    c:RegisterEffect(e1)
    --Banish
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(11511028,3))
    e2:SetCategory(CATEGORY_REMOVE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetLabel(x)
 	e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCountLimit(1)
    e2:SetCost(c11511028.cost)
    e2:SetTarget(c11511028.target)
    e2:SetOperation(c11511028.operation)
    e2:SetReset(RESET_EVENT+0x1fe0000)
    c:RegisterEffect(e2)
end
function c11511028.filterim(e,te)
	if e:GetLabel()==0 then
         return te:IsActiveType(TYPE_SYNCHRO) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
	else return te:IsActiveType(TYPE_XYZ) and te:GetOwnerPlayer()~=e:GetHandlerPlayer() end
end
function c11511028.filter(c,e)
	if e:GetLabel()==0 then
         return c:IsType(TYPE_SYNCHRO) and c:IsAbleToRemove() and c:IsFaceup()
	else return c:IsType(TYPE_XYZ) and c:IsAbleToRemove() and c:IsFaceup() end
end
function c11511028.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c11511028.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c11511028.filter,tp,0,LOCATION_MZONE,1,nil,e)  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c11511028.filter,tp,0,LOCATION_MZONE,1,1,nil,e)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c11511028.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end